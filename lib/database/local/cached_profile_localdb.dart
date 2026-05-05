// Contains Cache of profiles and source profiles for deck type

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/database/database.barrel.dart';

class CachedProfileLocalDB extends HiveLocalDB<CachedProfile> {
  @override
  String get boxName => 'cached_profile_box';

  @override
  String getId(CachedProfile item) => item.id;
}
