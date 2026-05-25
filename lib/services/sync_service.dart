// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/sync_service.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/database/local/hive.local.db.dart';
import 'package:boo_mondai/database/remote/supabase.remote.db.dart';
import 'package:boo_mondai/exceptions/exceptions.barrel.dart';
import 'package:boo_mondai/models/dto.dart';
import 'package:boo_mondai/services/services.dart';

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
  static Future<void> sync<T extends DTO>({
    required HiveLocalDB<T> localDb,
    required SupabaseRemoteDB<T> remoteDb,
    required String userId,
    bool Function(T item)? localWhere,
  }) async {
    try {
      _ensureAuthenticated(userId: userId);
      await pull(localDb: localDb, remoteDb: remoteDb, userId: userId);
      await push(
        localDb: localDb,
        remoteDb: remoteDb,
        userId: userId,
        localWhere: localWhere,
      );
    } catch (e) {
      // If it's already a SyncException, just rethrow it
      if (e is SyncException) rethrow;

      throw SyncException(
        'Unexpected error during full sync: $e',
        code: 'SYNC_FAILED',
      );
    }
  }

  /// Fetches remote records for [userId] and overwrites local if remote is newer.
  static Future<void> pull<T extends DTO>({
    required HiveLocalDB<T> localDb,
    required SupabaseRemoteDB<T> remoteDb,
    required String userId,
  }) async {
    try {
      _ensureAuthenticated(userId: userId);
      final remoteData = await remoteDb.selectMany(
        filters: {'user_id': userId},
      );
      for (final remote in remoteData) {
        final local = localDb.selectByPk({'id': remote.id});
        if (local == null || remote.updatedAt.isAfter(local.updatedAt)) {
          await localDb.upsert(remote);
        }
      }
    } catch (e) {
      throw SyncException(
        'Failed to pull remote data: $e',
        code: 'SYNC_PULL_FAILED',
      );
    }
  }

  /// Pushes local records to remote, skipping any where remote is newer.
  static Future<void> push<T extends DTO>({
    required HiveLocalDB<T> localDb,
    required SupabaseRemoteDB<T> remoteDb,
    required String userId,
    bool Function(T item)? localWhere,
  }) async {
    try {
      _ensureAuthenticated(userId: userId);
      final remoteData = await remoteDb.selectMany(
        filters: {'user_id': userId},
      );
      final remoteMap = {for (final r in remoteData) r.id: r};

      final localData = localDb.selectMany(where: localWhere);
      for (final local in localData) {
        final remote = remoteMap[local.id];
        if (remote == null || local.updatedAt.isAfter(remote.updatedAt)) {
          await remoteDb.upsert(local);
        }
      }
    } catch (e) {
      throw SyncException(
        'Failed to push local data: $e',
        code: 'SYNC_PUSH_FAILED',
      );
    }
  }
}
