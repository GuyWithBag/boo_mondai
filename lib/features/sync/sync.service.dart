// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/sync_service.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        SyncException,
        DTO,
        HiveLocalDB,
        SupabaseRemoteDB,
        ChangeRecord,
        ChangePreview,
        ChangeResult,
        ChangeTrackerStatus,
        ChangeTrackerController,
        ChangeSource,
        ChangeType,
        SyncPlanPayload,
        SyncSummary,
        AuthService;

/// Compares two DateTimes at millisecond precision, ignoring sub-millisecond
/// differences introduced by Supabase's microsecond storage vs Dart/Hive's
/// millisecond storage.
bool _isStrictlyAfterMs(DateTime a, DateTime b) {
  return a.toUtc().millisecondsSinceEpoch > b.toUtc().millisecondsSinceEpoch;
}

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
  static Future<bool> needsSync<T extends DTO>({
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
  static Future<ChangePreview<SyncPlanPayload<T>>> sync<T extends DTO>({
    required HiveLocalDB<T> localDb,
    required SupabaseRemoteDB<T> remoteDb,
    required String userId,
    required ChangeTrackerController reviewController,
    bool Function(T item)? localWhere,
  }) async {
    late final ChangePreview<SyncPlanPayload<T>> syncPlan;

    // 1. Force the _SyncPage loading screen to appear immediately
    final entry = reviewController.start(
      source: ChangeSource.sync,
      title: 'Sync',
      status: ChangeTrackerStatus.previewing,
      progress: 0.1,
      onApply: () async {
        // This captures the 'syncPlan' variable once it's populated below
        final result = await applySync(
          plan: syncPlan,
          localDb: localDb,
          remoteDb: remoteDb,
        );
        return result.changes;
      },
    );

    try {
      _ensureAuthenticated(userId: userId);

      // 2. Perform the ultra-fast check
      final isSyncNeeded = await needsSync(
        localDb: localDb,
        remoteDb: remoteDb,
        userId: userId,
        localWhere: localWhere,
      );

      // 3. IF NO SYNC NEEDED: Bail out instantly to the new status
      if (!isSyncNeeded) {
        reviewController.update(
          entry.id,
          status: ChangeTrackerStatus.alreadyUpToDate,
          progress: 1.0,
        );

        // Initialize the late variable to an empty state
        syncPlan = ChangePreview(
          payload: SyncPlanPayload<T>(
            tableName: remoteDb.tableName,
            pullItems: const [],
            pushItems: const [],
            skipped: 0,
          ),
          changes: const [],
        );
        return syncPlan;
      }

      // 4. IF SYNC NEEDED: Do the heavy lifting (download and diff)
      reviewController.update(entry.id, progress: 0.4);
      syncPlan = await previewSync(
        localDb: localDb,
        remoteDb: remoteDb,
        userId: userId,
        localWhere: localWhere,
      );

      // 5. Double check (just in case previewSync found no actionable changes)
      if (syncPlan.changes.isEmpty) {
        reviewController.update(
          entry.id,
          status: ChangeTrackerStatus.alreadyUpToDate,
          progress: 1.0,
        );
        return syncPlan;
      }

      // 6. We have confirmed changes! Move to reviewing so the user can Apply.
      reviewController.update(
        entry.id,
        status: ChangeTrackerStatus.reviewing,
        progress: 1.0,
        changes: syncPlan.changes,
      );

      return syncPlan;
    } catch (e) {
      reviewController.fail(entry.id, e);

      if (e is SyncException) rethrow;
      throw SyncException(
        'Unexpected error during sync: $e',
        code: 'SYNC_FAILED',
      );
    }
  }

  /// Previews pull/push decisions without mutating local or remote data.
  static Future<ChangePreview<SyncPlanPayload<T>>> previewSync<T extends DTO>({
    required HiveLocalDB<T> localDb,
    required SupabaseRemoteDB<T> remoteDb,
    required String userId,
    bool Function(T item)? localWhere,
  }) async {
    try {
      _ensureAuthenticated(userId: userId);
      final changes = <ChangeRecord>[];
      final pullItems = <T>[];
      final pushItems = <T>[];
      var skipped = 0;

      final remoteData = await remoteDb.selectMany(
        filters: {'user_id': userId},
      );
      final localData = localDb.selectMany(where: localWhere);
      final remoteMap = {for (final remote in remoteData) remote.id: remote};
      final localMap = {for (final local in localData) local.id: local};

      for (final remote in remoteData) {
        final local = localMap[remote.id];
        if (local == null) {
          pullItems.add(remote);
          changes.add(
            ChangeRecord(
              type: ChangeType.added,
              source: ChangeSource.sync,
              entityType: remoteDb.tableName,
              entityId: remote.id,
              title: 'Pull new ${remoteDb.tableName} record',
              remoteId: remote.id,
              remoteUpdatedAt: remote.updatedAt,
            ),
          );
          continue;
        }

        if (_isStrictlyAfterMs(remote.updatedAt, local.updatedAt)) {
          pullItems.add(remote);
          changes.add(
            ChangeRecord(
              type: ChangeType.modified,
              source: ChangeSource.sync,
              entityType: remoteDb.tableName,
              entityId: remote.id,
              title: 'Pull newer ${remoteDb.tableName} record',
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
            ChangeRecord(
              type: ChangeType.added,
              source: ChangeSource.sync,
              entityType: remoteDb.tableName,
              entityId: local.id,
              title: 'Push new ${remoteDb.tableName} record',
              localId: local.id,
              localUpdatedAt: local.updatedAt,
            ),
          );
          continue;
        }

        if (_isStrictlyAfterMs(local.updatedAt, remote.updatedAt)) {
          pushItems.add(local);
          changes.add(
            ChangeRecord(
              type: ChangeType.modified,
              source: ChangeSource.sync,
              entityType: remoteDb.tableName,
              entityId: local.id,
              title: 'Push newer ${remoteDb.tableName} record',
              localId: local.id,
              remoteId: remote.id,
              localUpdatedAt: local.updatedAt,
              remoteUpdatedAt: remote.updatedAt,
            ),
          );
        }
      }

      return ChangePreview(
        payload: SyncPlanPayload<T>(
          tableName: remoteDb.tableName,
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
  static Future<ChangeResult<SyncSummary>> applySync<T extends DTO>({
    required ChangePreview<SyncPlanPayload<T>> plan,
    required HiveLocalDB<T> localDb,
    required SupabaseRemoteDB<T> remoteDb,
  }) async {
    try {
      for (final remote in plan.payload.pullItems) {
        await localDb.upsert(remote);
      }
      for (final local in plan.payload.pushItems) {
        await remoteDb.upsert(local);
      }
      return ChangeResult(value: plan.payload.summary, changes: plan.changes);
    } catch (e) {
      throw SyncException(
        'Failed to apply sync data: $e',
        code: 'SYNC_APPLY_FAILED',
      );
    }
  }

  /// Previews and applies sync immediately without registering a review UI.
  static Future<ChangeResult<SyncSummary>> syncImmediately<T extends DTO>({
    required HiveLocalDB<T> localDb,
    required SupabaseRemoteDB<T> remoteDb,
    required String userId,
    bool Function(T item)? localWhere,
  }) async {
    final isSyncNeeded = await needsSync(
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

    final plan = await previewSync(
      localDb: localDb,
      remoteDb: remoteDb,
      userId: userId,
      localWhere: localWhere,
    );
    return applySync(plan: plan, localDb: localDb, remoteDb: remoteDb);
  }
}
