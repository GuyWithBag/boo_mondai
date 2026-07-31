import 'package:boo_mondai/lib.barrel.dart'
    show HiveSingleDataLocalDB, LocalDB, SyncClient;

class SyncClientLocalDB extends HiveSingleDataLocalDB<SyncClient> {
  @override
  String get boxName => 'sync_client';

  @override
  String getId(SyncClient item) => item.id;

  @override
  SyncClient createValue() {
    final profileId = LocalDB.profile.getOrCreate().id;
    return SyncClient.create(profileId: profileId);
  }
}
