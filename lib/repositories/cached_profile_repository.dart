// Contains Cache of profiles and source profiles for deck type

import 'package:boo_mondai/models/cached_profile.dart';

import 'hive_repository.dart';

class CachedProfileRepository extends HiveRepository<CachedProfile> {
  @override
  String get boxName => 'cached_profile_box';

  @override
  String getId(CachedProfile item) => item.id;
}
