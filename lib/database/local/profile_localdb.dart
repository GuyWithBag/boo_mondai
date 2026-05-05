// Contains Cache of profiles and source profiles for deck type

import 'package:boo_mondai/models/user_profile.dart';
import 'package:boo_mondai/database/database.barrel.dart';

class ProfileLocalDB extends HiveLocalDB<UserProfile> {
  @override
  String get boxName => 'profile_box';

  @override
  String getId(UserProfile item) => item.id;
}
