import 'package:boo_mondai/lib.barrel.dart'
    show SupabaseRemoteDB, SyncClient, SyncClientMapper;

class SyncClientsRemoteDB extends SupabaseRemoteDB<SyncClient> {
  @override
  String get tableName => 'sync_clients';

  @override
  SyncClient Function(Map<String, dynamic>) get fromMap =>
      SyncClientMapper.fromMap;

  @override
  Map<String, dynamic> toMap(SyncClient item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(SyncClient item) => {
    'id': item.id,
    'profile_id': item.profileId,
  };

  @override
  String get upsertConflictTarget => 'id,profile_id';

  Future<void> touchSeen({
    required String clientId,
    required String profileId,
  }) async {
    final now = DateTime.now();
    final primaryKey = {'id': clientId, 'profile_id': profileId};
    final existing = await selectOne(filters: primaryKey);
    if (existing == null) {
      await upsert(
        SyncClient(
          id: clientId,
          profileId: profileId,
          createdAt: now,
          lastSeenAt: now,
        ),
      );
      return;
    }

    await updateWhere(
      filters: primaryKey,
      values: {'last_seen_at': now.toUtc().toIso8601String()},
    );
  }

  Future<void> markSynced({
    required String clientId,
    required String profileId,
  }) async {
    final now = DateTime.now();
    final primaryKey = {'id': clientId, 'profile_id': profileId};
    final existing = await selectOne(filters: primaryKey);
    if (existing == null) {
      await upsert(
        SyncClient(
          id: clientId,
          profileId: profileId,
          createdAt: now,
          lastSeenAt: now,
          lastSyncedAt: now,
        ),
      );
      return;
    }

    await updateWhere(
      filters: primaryKey,
      values: {
        'last_seen_at': now.toUtc().toIso8601String(),
        'last_synced_at': now.toUtc().toIso8601String(),
      },
    );
  }

  Future<List<SyncClient>> selectActiveByProfileId({
    required String profileId,
    required Duration activeClientWindow,
  }) {
    final cutoff = DateTime.now().subtract(activeClientWindow);
    return selectMany(filters: {'profile_id': profileId}).then(
      (clients) => clients
          .where((client) => client.lastSeenAt.isAfter(cutoff))
          .toList(growable: false),
    );
  }

  Future<void> purgeSyncTombstones({
    required Duration activeClientWindow,
  }) async {
    await guard(
      () => client.rpc(
        'purge_sync_tombstones',
        params: {'active_client_window': '${activeClientWindow.inDays} days'},
      ),
      action: 'purgeSyncTombstones',
    );
  }
}
