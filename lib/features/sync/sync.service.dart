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
        SyncChangeLog,
        SyncChangeType,
        SyncOperationType,
        SyncOperationLog,
        SyncOperationProgress,
        SyncResult;

class SyncService {
  static void _ensureAuthenticated({required String userId}) {
    if (!Services.auth.isAuthenticatedRemote || userId.trim().isEmpty) {
      throw const SyncException(
        'Sign in to sync your data.',
        code: 'SYNC_AUTH_REQUIRED',
      );
    }
  }

  /// Pulls remote data, then pushes local data.
  /// Conflict resolution: newest updatedAt wins.
  static Future<SyncResult> sync<T extends DTO>({
    required HiveLocalDB<T> localDb,
    required SupabaseRemoteDB<T> remoteDb,
    required String userId,
    bool Function(T item)? localWhere,
  }) async {
    final operation = SyncOperationLog.instance.start(
      kind: SyncOperationType.fullSync,
      subjectId: '${remoteDb.tableName}:$userId',
      subjectTitle: remoteDb.tableName,
      progress: const SyncOperationProgress.indeterminate(
        label: 'Preparing sync',
      ),
    );

    try {
      _ensureAuthenticated(userId: userId);
      SyncOperationLog.instance.update(
        operation.id,
        progress: const SyncOperationProgress(
          completed: 0,
          total: 2,
          label: 'Pulling remote changes',
        ),
      );
      final pullResult = await pull(
        localDb: localDb,
        remoteDb: remoteDb,
        userId: userId,
      );

      SyncOperationLog.instance.update(
        operation.id,
        progress: SyncOperationProgress(
          completed: 1,
          total: 2,
          label: 'Pushing local changes',
        ),
        changes: pullResult.changes,
      );
      final pushResult = await push(
        localDb: localDb,
        remoteDb: remoteDb,
        userId: userId,
        localWhere: localWhere,
      );
      final result = pullResult.combine(pushResult);

      SyncOperationLog.instance.succeed(
        operation.id,
        progress: const SyncOperationProgress(
          completed: 2,
          total: 2,
          label: 'Sync complete',
        ),
        changes: result.changes,
      );
      return result;
    } catch (e) {
      SyncOperationLog.instance.fail(operation.id, e);

      // If it's already a SyncException, just rethrow it
      if (e is SyncException) rethrow;

      throw SyncException(
        'Unexpected error during full sync: $e',
        code: 'SYNC_FAILED',
      );
    }
  }

  /// Fetches remote records for [userId] and overwrites local if remote is newer.
  static Future<SyncResult> pull<T extends DTO>({
    required HiveLocalDB<T> localDb,
    required SupabaseRemoteDB<T> remoteDb,
    required String userId,
  }) async {
    try {
      _ensureAuthenticated(userId: userId);
      final changes = <SyncChangeLog>[];
      var pulled = 0;
      var skipped = 0;
      final remoteData = await remoteDb.selectMany(
        filters: {'user_id': userId},
      );
      for (final remote in remoteData) {
        final local = localDb.selectByPk({'id': remote.id});
        if (local == null) {
          await localDb.upsert(remote);
          pulled++;
          changes.add(
            SyncChangeLog(
              type: SyncChangeType.created,
              entityType: remoteDb.tableName,
              entityId: remote.id,
              remoteId: remote.id,
              remoteUpdatedAt: remote.updatedAt,
              message: 'Pulled new ${remoteDb.tableName} record.',
            ),
          );
        } else if (remote.updatedAt.isAfter(local.updatedAt)) {
          await localDb.upsert(remote);
          pulled++;
          changes.add(
            SyncChangeLog(
              type: SyncChangeType.updated,
              entityType: remoteDb.tableName,
              entityId: remote.id,
              localId: local.id,
              remoteId: remote.id,
              localUpdatedAt: local.updatedAt,
              remoteUpdatedAt: remote.updatedAt,
              message: 'Pulled newer ${remoteDb.tableName} record.',
            ),
          );
        } else {
          skipped++;
        }
      }
      return SyncResult(changes: changes, pulled: pulled, skipped: skipped);
    } catch (e) {
      throw SyncException(
        'Failed to pull remote data: $e',
        code: 'SYNC_PULL_FAILED',
      );
    }
  }

  /// Pushes local records to remote, skipping any where remote is newer.
  static Future<SyncResult> push<T extends DTO>({
    required HiveLocalDB<T> localDb,
    required SupabaseRemoteDB<T> remoteDb,
    required String userId,
    bool Function(T item)? localWhere,
  }) async {
    try {
      _ensureAuthenticated(userId: userId);
      final changes = <SyncChangeLog>[];
      var pushed = 0;
      var skipped = 0;
      final remoteData = await remoteDb.selectMany(
        filters: {'user_id': userId},
      );
      final remoteMap = {for (final r in remoteData) r.id: r};

      final localData = localDb.selectMany(where: localWhere);
      for (final local in localData) {
        final remote = remoteMap[local.id];
        if (remote == null) {
          await remoteDb.upsert(local);
          pushed++;
          changes.add(
            SyncChangeLog(
              type: SyncChangeType.created,
              entityType: remoteDb.tableName,
              entityId: local.id,
              localId: local.id,
              localUpdatedAt: local.updatedAt,
              message: 'Pushed new ${remoteDb.tableName} record.',
            ),
          );
        } else if (local.updatedAt.isAfter(remote.updatedAt)) {
          await remoteDb.upsert(local);
          pushed++;
          changes.add(
            SyncChangeLog(
              type: SyncChangeType.updated,
              entityType: remoteDb.tableName,
              entityId: local.id,
              localId: local.id,
              remoteId: remote.id,
              localUpdatedAt: local.updatedAt,
              remoteUpdatedAt: remote.updatedAt,
              message: 'Pushed newer ${remoteDb.tableName} record.',
            ),
          );
        } else {
          skipped++;
        }
      }
      return SyncResult(changes: changes, pushed: pushed, skipped: skipped);
    } catch (e) {
      throw SyncException(
        'Failed to push local data: $e',
        code: 'SYNC_PUSH_FAILED',
      );
    }
  }
}
