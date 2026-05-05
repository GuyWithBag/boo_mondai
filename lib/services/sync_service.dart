// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/sync_service.dart
// PURPOSE: Generic pull-then-push sync between HiveLocalDB and SupabaseRemoteDB
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/database/local/hive_localdb.dart';
import 'package:boo_mondai/database/remote/supabase_remotedb.dart';
import 'package:boo_mondai/models/dto.dart';

class SyncService {
  /// Pulls remote data, then pushes local data.
  /// Conflict resolution: newest updatedAt wins.
  static Future<void> sync<T extends DTO>({
    required HiveLocalDB<T> localDb,
    required SupabaseRemoteDB<T> remoteDb,
    required String userId,
  }) async {
    await pull(localDb: localDb, remoteDb: remoteDb, userId: userId);
    await push(localDb: localDb, remoteDb: remoteDb, userId: userId);
  }

  /// Fetches remote records for [userId] and overwrites local if remote is newer.
  static Future<void> pull<T extends DTO>({
    required HiveLocalDB<T> localDb,
    required SupabaseRemoteDB<T> remoteDb,
    required String userId,
  }) async {
    final remoteData = await remoteDb.selectManyByUserId(userId);
    for (final remote in remoteData) {
      final local = localDb.getById(remote.id);
      if (local == null || remote.updatedAt.isAfter(local.updatedAt)) {
        await localDb.put(remote);
      }
    }
  }

  /// Pushes local records to remote, skipping any where remote is newer.
  static Future<void> push<T extends DTO>({
    required HiveLocalDB<T> localDb,
    required SupabaseRemoteDB<T> remoteDb,
    required String userId,
  }) async {
    final remoteData = await remoteDb.selectManyByUserId(userId);
    final remoteMap = {for (final r in remoteData) r.id: r};

    final localData = localDb.getAll();
    for (final local in localData) {
      final remote = remoteMap[local.id];
      if (remote == null || local.updatedAt.isAfter(remote.updatedAt)) {
        await remoteDb.upsertOne(local);
      }
    }
  }
}
