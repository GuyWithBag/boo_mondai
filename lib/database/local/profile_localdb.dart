// Contains Cache of profiles and source profiles for deck type

import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';

class ProfileLocalDB extends HiveLocalDB<Profile> {
  @override
  String get boxName => 'profile_box';

  @override
  String getId(Profile item) => item.id;
}
