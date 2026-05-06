// Contains Cache of profiles and source profiles for deck type

import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/services/services.barrel.dart';

class ProfileLocalDB extends HiveSingleDataLocalDB<Profile> {
  @override
  String get boxName => 'profile_box';

  @override
  String getId(Profile item) => item.id;

  @override
  Profile createValue() {
    final profile = Profile(
      id: UuidService.uuid.v4(),
      // This will be replaced by supabase's auth.user auto generated uuid.
      userId: UuidService.uuid.v4(),
      role: '',
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
      username: 'Anonymous',
    );
    return profile;
  }
}
