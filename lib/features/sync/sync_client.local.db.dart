import 'package:boo_mondai/lib.barrel.dart'
    show HiveSingleDataLocalDB, LocalDB, SyncClient;

class SyncClientLocalDB extends HiveSingleDataLocalDB<SyncClient> {
  @override
  String get boxName => 'sync_client';

  @override
  Map<String, Object?> primaryKeyFromItem(SyncClient item) => {'id': item.id};

  @override
  SyncClient createValue() {
    final profileId = LocalDB.currentProfile.getOrCreate().id;
    return SyncClient.create(profileId: profileId);
  }
}
