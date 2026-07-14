// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/sync_service.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AuthService,
        PreviewedChangePlan,
        ChangedEntity,
        ChangeResult,
        ChangeSource,
        ChangeTrackerController,
        ChangeTrackerEntry,
        ChangeTrackerStatus,
        ChangeType,
        MutableEntity,
        HiveLocalDB,
        ProgressCheckpointService,
        ProgressCheckpointType,
        SupabaseRemoteDB,
        SyncException,
        SyncPlanPayload,
        SyncSummary;

/// Compares two DateTimes at millisecond precision, ignoring sub-millisecond
/// differences introduced by Supabase's microsecond storage vs Dart/Hive's
/// millisecond storage.
bool _isStrictlyAfterMs(DateTime a, DateTime b) {
  return a.toUtc().millisecondsSinceEpoch > b.toUtc().millisecondsSinceEpoch;
}

const _kSyncPageSize = 100;

class SyncService {
  static void _ensureAuthenticated({required String userId}) {
    if (!AuthService.isAuthenticatedRemote || userId.trim().isEmpty) {
      throw const SyncException(
        'Sign in to sync your data.',
        code: 'SYNC_AUTH_REQUIRED',
      );
    }
  }

  /// Performs a highly-optimized network request to check if a sync is needed
  /// by ONLY downloading IDs and timestamps, bypassing heavy joined data.
  static Future<bool> doesTableNeedSync<T extends MutableEntity>({
    required HiveLocalDB<T> localDb,
    required SupabaseRemoteDB<T> remoteDb,
    required String userId,
    bool Function(T item)? localWhere,
  }) async {
    _ensureAuthenticated(userId: userId);

    try {
      final localData = localDb.selectMany(where: localWhere);
      final localMap = {for (final local in localData) local.id: local};

      final remoteData = await remoteDb.client
          .from(remoteDb.tableName)
          .select('id, updated_at')
          .eq('user_id', userId);

      final remoteMap = <String, DateTime>{};
      for (final row in remoteData) {
        final id = row['id'] as String;
        final updatedAtStr = row['updated_at'] as String?;
        if (updatedAtStr != null) {
          remoteMap[id] = DateTime.parse(updatedAtStr);
        }
      }

      for (final entry in remoteMap.entries) {
        final local = localMap[entry.key];
        if (local == null || _isStrictlyAfterMs(entry.value, local.updatedAt)) {
          return true;
        }
      }

      for (final local in localData) {
        final remoteUpdatedAt = remoteMap[local.id];
        if (remoteUpdatedAt == null ||
            _isStrictlyAfterMs(local.updatedAt, remoteUpdatedAt)) {
          return true;
        }
      }

      return false;
    } catch (e) {
      return true;
    }
  }

  /// Builds a sync preview and registers its apply step with the ChangeTrackerController.
  static Future<PreviewedChangePlan<SyncPlanPayload<T>, T>>
  sync<T extends MutableEntity>({
    required HiveLocalDB<T> localDb,
    required SupabaseRemoteDB<T> remoteDb,
    required String userId,
    required ChangeTrackerController changeTrackerController,
    ProgressCheckpointService? progressCheckpointService,
    bool Function(T item)? localWhere,
  }) async {
    late final PreviewedChangePlan<SyncPlanPayload<T>, T> syncPlan;

    // 1. Force the _SyncPage loading screen to appear immediately
    final entry = changeTrackerController.start<T>(
      entry: ChangeTrackerEntry(
        source: ChangeSource.sync,
        title: 'Sync',
        status: ChangeTrackerStatus.planning,
        progress: 0.1,
      ),
      onApply: () async {
        // This captures the 'syncPlan' variable once it's populated below
        final result = await applySync<T>(
          plan: syncPlan,
          localDb: localDb,
          remoteDb: remoteDb,
          progressCheckpointService: progressCheckpointService,
        );
        return result.changes;
      },
    );

    try {
      _ensureAuthenticated(userId: userId);

      // 2. Perform the ultra-fast check
      changeTrackerController.update(
        entry.id,
        status: ChangeTrackerStatus.fetching,
        progress: 0.2,
      );
      final isSyncNeeded = await doesTableNeedSync<T>(
        localDb: localDb,
        remoteDb: remoteDb,
        userId: userId,
        localWhere: localWhere,
      );

      // 3. IF NO SYNC NEEDED: Bail out instantly to the new status
      if (!isSyncNeeded) {
        changeTrackerController.update(
          entry.id,
          status: ChangeTrackerStatus.alreadyUpToDate,
          progress: 1.0,
        );

        // Initialize the late variable to an empty state
        syncPlan = PreviewedChangePlan(
          payload: SyncPlanPayload<T>(
            tableName: remoteDb.tableName,
            checkpointTargetId: _syncTargetId(userId, remoteDb.tableName),
            pullItems: const [],
            pushItems: const [],
            skipped: 0,
          ),
          changes: const [],
        );

        return syncPlan;
      }

      // 4. IF SYNC NEEDED: Do the heavy lifting (download and diff)
      changeTrackerController.update(
        entry.id,
        status: ChangeTrackerStatus.fetching,
        progress: 0.4,
      );
      syncPlan = await previewSyncPlan<T>(
        localDb: localDb,
        remoteDb: remoteDb,
        userId: userId,
        progressCheckpointService: progressCheckpointService,
        localWhere: localWhere,
      );

      // 5. Double check (just in case previewSyncPlan found no actionable changes)
      if (syncPlan.changes.isEmpty) {
        changeTrackerController.update(
          entry.id,
          status: ChangeTrackerStatus.alreadyUpToDate,
          progress: 1.0,
        );
        return syncPlan;
      }

      // 6. We have confirmed changes! Move to reviewing so the user can Apply.
      changeTrackerController.update(
        entry.id,
        status: ChangeTrackerStatus.reviewing,
        progress: 1.0,
        changes: syncPlan.changes,
      );

      return syncPlan;
    } catch (e) {
      changeTrackerController.fail(entry.id, e);

      if (e is SyncException) rethrow;
      throw SyncException(
        'Unexpected error during sync: $e',
        code: 'SYNC_FAILED',
      );
    }
  }

  /// Previews pull/push decisions without mutating local or remote data.
  static Future<PreviewedChangePlan<SyncPlanPayload<T>, T>>
  previewSyncPlan<T extends MutableEntity>({
    required HiveLocalDB<T> localDb,
    required SupabaseRemoteDB<T> remoteDb,
    required String userId,
    ProgressCheckpointService? progressCheckpointService,
    bool Function(T item)? localWhere,
  }) async {
    try {
      _ensureAuthenticated(userId: userId);
      final checkpointService =
          progressCheckpointService ?? ProgressCheckpointService();
      final checkpointTargetId = _syncTargetId(userId, remoteDb.tableName);
      final changes = <ChangedEntity<T>>[];
      final pullItems = <T>[];
      final pushItems = <T>[];
      var skipped = 0;

      final remoteFilters = {'user_id': userId};
      final remoteTotal = await remoteDb.count(filters: remoteFilters);
      var fetchCheckpoint = checkpointService.start(
        type: ProgressCheckpointType.syncFetch,
        targetId: checkpointTargetId,
        operationDescription: 'Fetching sync data for ${remoteDb.tableName}',
        totalItems: remoteTotal,
        preserveCompletedItems: false,
      );
      final remoteData = <T>[];
      var remoteOffset = 0;
      final fetchedRemoteIds = fetchCheckpoint.completedTargetItemIds.toSet();

      while (remoteOffset < remoteTotal) {
        final page = await remoteDb.selectManyPaged(
          filters: remoteFilters,
          orderBy: 'id',
          offset: remoteOffset,
          pageSize: _kSyncPageSize,
        );
        if (page.isEmpty) break;

        remoteData.addAll(page);
        final pageIds = page
            .map((item) => item.id)
            .where((id) => fetchedRemoteIds.add(id))
            .toList();
        fetchCheckpoint = checkpointService.markItemsCompleted(
          checkpointId: fetchCheckpoint.id,
          itemIds: pageIds,
        );
        remoteOffset = fetchCheckpoint.completedTargetItemIds.length;
      }
      checkpointService.complete(fetchCheckpoint.id);

      final localData = localDb.selectMany(where: localWhere);
      final remoteMap = {for (final remote in remoteData) remote.id: remote};
      final localMap = {for (final local in localData) local.id: local};

      for (final remote in remoteData) {
        final local = localMap[remote.id];
        if (local == null) {
          pullItems.add(remote);
          changes.add(
            ChangedEntity(
              changeType: ChangeType.added,
              source: ChangeSource.sync,
              id: remote.id,
              afterChange: remote,
              remoteId: remote.id,
              remoteUpdatedAt: remote.updatedAt,
            ),
          );
          continue;
        }

        if (_isStrictlyAfterMs(remote.updatedAt, local.updatedAt)) {
          pullItems.add(remote);
          changes.add(
            ChangedEntity(
              changeType: ChangeType.modified,
              source: ChangeSource.sync,
              id: remote.id,
              beforeChange: local,
              afterChange: remote,
              localId: local.id,
              remoteId: remote.id,
              localUpdatedAt: local.updatedAt,
              remoteUpdatedAt: remote.updatedAt,
            ),
          );
        } else if (!_isStrictlyAfterMs(local.updatedAt, remote.updatedAt)) {
          skipped++;
        }
      }

      for (final local in localData) {
        final remote = remoteMap[local.id];
        if (remote == null) {
          pushItems.add(local);
          changes.add(
            ChangedEntity(
              changeType: ChangeType.added,
              source: ChangeSource.sync,
              id: local.id,
              afterChange: local,
              localId: local.id,
              localUpdatedAt: local.updatedAt,
            ),
          );
          continue;
        }

        if (_isStrictlyAfterMs(local.updatedAt, remote.updatedAt)) {
          pushItems.add(local);
          changes.add(
            ChangedEntity(
              changeType: ChangeType.modified,
              source: ChangeSource.sync,
              id: local.id,
              beforeChange: remote,
              afterChange: local,
              localId: local.id,
              remoteId: remote.id,
              localUpdatedAt: local.updatedAt,
              remoteUpdatedAt: remote.updatedAt,
            ),
          );
        }
      }

      return PreviewedChangePlan<SyncPlanPayload<T>, T>(
        payload: SyncPlanPayload<T>(
          tableName: remoteDb.tableName,
          checkpointTargetId: checkpointTargetId,
          pullItems: pullItems,
          pushItems: pushItems,
          skipped: skipped,
        ),
        changes: changes,
      );
    } catch (e) {
      throw SyncException(
        'Failed to preview sync data: $e',
        code: 'SYNC_PREVIEW_FAILED',
      );
    }
  }

  /// Applies a previously previewed sync plan.
  static Future<ChangeResult<SyncSummary, T>>
  applySync<T extends MutableEntity>({
    required PreviewedChangePlan<SyncPlanPayload<T>, T> plan,
    required HiveLocalDB<T> localDb,
    required SupabaseRemoteDB<T> remoteDb,
    ProgressCheckpointService? progressCheckpointService,
  }) async {
    final checkpointService =
        progressCheckpointService ?? ProgressCheckpointService();
    final checkpoint = checkpointService.start(
      type: ProgressCheckpointType.syncApply,
      targetId: plan.payload.checkpointTargetId,
      operationDescription: 'Applying sync for ${plan.payload.tableName}',
      totalItems: plan.payload.pullItems.length + plan.payload.pushItems.length,
    );
    final completed = checkpoint.completedTargetItemIds.toSet();

    try {
      var currentCheckpoint = checkpoint;
      for (
        var offset = 0;
        offset < plan.payload.pullItems.length;
        offset += _kSyncPageSize
      ) {
        final page = plan.payload.pullItems.skip(offset).take(_kSyncPageSize);
        final completedPageIds = <String>[];
        for (final remote in page) {
          if (completed.contains(remote.id)) continue;
          await localDb.upsert(remote);
          completed.add(remote.id);
          completedPageIds.add(remote.id);
        }
        currentCheckpoint = checkpointService.markItemsCompleted(
          checkpointId: currentCheckpoint.id,
          itemIds: completedPageIds,
        );
      }
      for (
        var offset = 0;
        offset < plan.payload.pushItems.length;
        offset += _kSyncPageSize
      ) {
        final page = plan.payload.pushItems.skip(offset).take(_kSyncPageSize);
        final completedPageIds = <String>[];
        for (final local in page) {
          if (completed.contains(local.id)) continue;
          await remoteDb.upsert(local);
          completed.add(local.id);
          completedPageIds.add(local.id);
        }
        currentCheckpoint = checkpointService.markItemsCompleted(
          checkpointId: currentCheckpoint.id,
          itemIds: completedPageIds,
        );
      }
      checkpointService.complete(currentCheckpoint.id);
      return ChangeResult(value: plan.payload.summary, changes: plan.changes);
    } catch (e) {
      checkpointService.fail(checkpoint.id);
      throw SyncException(
        'Failed to apply sync data: $e',
        code: 'SYNC_APPLY_FAILED',
      );
    }
  }

  /// Previews and applies sync immediately without registering a review UI.
  static Future<ChangeResult<SyncSummary, T>>
  syncImmediately<T extends MutableEntity>({
    required HiveLocalDB<T> localDb,
    required SupabaseRemoteDB<T> remoteDb,
    required String userId,
    bool Function(T item)? localWhere,
  }) async {
    final isSyncNeeded = await doesTableNeedSync<T>(
      localDb: localDb,
      remoteDb: remoteDb,
      userId: userId,
      localWhere: localWhere,
    );

    if (!isSyncNeeded) {
      return const ChangeResult(
        value: SyncSummary(pulled: 0, pushed: 0, skipped: 0),
        changes: [],
      );
    }

    final plan = await previewSyncPlan<T>(
      localDb: localDb,
      remoteDb: remoteDb,
      userId: userId,
      localWhere: localWhere,
    );
    return applySync(plan: plan, localDb: localDb, remoteDb: remoteDb);
  }

  static String _syncTargetId(String userId, String tableName) =>
      '$userId:$tableName';
}
