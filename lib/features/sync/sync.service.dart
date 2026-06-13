// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/sync_service.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        Services,
        SyncException,
        DTO,
        HiveLocalDB,
        SupabaseRemoteDB,
        ChangeLog,
        ChangePlan,
        ChangeResult,
        ChangeReviewStatus,
        ChangeReviewStore,
        ChangeSource,
        ChangeType,
        SyncPlanPayload,
        SyncSummary;

class SyncService {
  static void _ensureAuthenticated({required String userId}) {
    if (!Services.auth.isAuthenticatedRemote || userId.trim().isEmpty) {
      throw const SyncException(
        'Sign in to sync your data.',
        code: 'SYNC_AUTH_REQUIRED',
      );
    }
  }

  /// Builds a sync preview and registers its apply step with ChangeReviewStore.
  static Future<ChangePlan<SyncPlanPayload<T>>> sync<T extends DTO>({
    required HiveLocalDB<T> localDb,
    required SupabaseRemoteDB<T> remoteDb,
    required String userId,
    bool Function(T item)? localWhere,
  }) async {
    late final ChangePlan<SyncPlanPayload<T>> syncPlan;
    final reviewPlan = ChangeReviewStore.instance.start(
      source: ChangeSource.sync,
      title: 'Sync',
      status: ChangeReviewStatus.previewing,
      progress: 0,
      onApply: () async {
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
      ChangeReviewStore.instance.update(reviewPlan.id, progress: 0.35);
      syncPlan = await previewSync(
        localDb: localDb,
        remoteDb: remoteDb,
        userId: userId,
        localWhere: localWhere,
      );
      ChangeReviewStore.instance.update(
        reviewPlan.id,
        status: ChangeReviewStatus.reviewing,
        progress: 1,
        changes: syncPlan.changes,
      );
      return syncPlan;
    } catch (e) {
      ChangeReviewStore.instance.fail(reviewPlan.id, e);

      if (e is SyncException) rethrow;

      throw SyncException(
        'Unexpected error during sync preview: $e',
        code: 'SYNC_PREVIEW_FAILED',
      );
    }
  }

  /// Previews pull/push decisions without mutating local or remote data.
  static Future<ChangePlan<SyncPlanPayload<T>>> previewSync<T extends DTO>({
    required HiveLocalDB<T> localDb,
    required SupabaseRemoteDB<T> remoteDb,
    required String userId,
    bool Function(T item)? localWhere,
  }) async {
    try {
      _ensureAuthenticated(userId: userId);
      final changes = <ChangeLog>[];
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
            ChangeLog(
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

        if (remote.updatedAt.isAfter(local.updatedAt)) {
          pullItems.add(remote);
          changes.add(
            ChangeLog(
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
        } else if (!local.updatedAt.isAfter(remote.updatedAt)) {
          skipped++;
        }
      }

      for (final local in localData) {
        final remote = remoteMap[local.id];
        if (remote == null) {
          pushItems.add(local);
          changes.add(
            ChangeLog(
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

        if (local.updatedAt.isAfter(remote.updatedAt)) {
          pushItems.add(local);
          changes.add(
            ChangeLog(
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

      return ChangePlan(
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
    required ChangePlan<SyncPlanPayload<T>> plan,
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
    final plan = await previewSync(
      localDb: localDb,
      remoteDb: remoteDb,
      userId: userId,
      localWhere: localWhere,
    );
    return applySync(plan: plan, localDb: localDb, remoteDb: remoteDb);
  }
}
