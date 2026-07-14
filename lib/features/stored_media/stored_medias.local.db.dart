import 'package:boo_mondai/lib.barrel.dart' show HiveLocalDB, StoredMedia;

class StoredMediasLocalDB extends HiveLocalDB<StoredMedia> {
  @override
  String get boxName => 'stored_medias';

  @override
  Map<String, Object?> primaryKeyFromItem(StoredMedia item) => {'id': item.id};
}
