// Contains Cache of profiles and source profiles for deck type

import 'package:boo_mondai/lib.barrel.dart' show HiveLocalDB, CachedProfile;

class CachedProfileLocalDB extends HiveLocalDB<CachedProfile> {
  @override
  String get boxName => 'cached_profiles';

  @override
  Map<String, Object?> primaryKeyFromItem(CachedProfile item) => {
    'id': item.id,
  };
}
