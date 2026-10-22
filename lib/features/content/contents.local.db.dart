import 'package:boo_mondai/lib.barrel.dart' show Content, HiveLocalDB;

class ContentsLocalDB extends HiveLocalDB<Content> {
  @override
  String get boxName => 'contents';

  @override
  Map<String, Object?> primaryKeyFromItem(Content item) => {'id': item.id};
}
