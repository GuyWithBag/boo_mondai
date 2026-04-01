// Contains Cache of profiles and source profiles for deck type

import 'package:boo_mondai/models/user_profile.dart';

import 'hive_repository.dart';

class ProfileRepository extends HiveRepository<UserProfile> {
  @override
  String get boxName => 'profile_box';

  @override
  String getId(UserProfile item) => item.id;
}
