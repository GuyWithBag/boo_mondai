// Contains Cache of profiles and source profiles for deck type

import 'package:boo_mondai/lib.barrel.dart'
    show HiveSingleDataLocalDB, Profile, uuid;

class ProfileLocalDB extends HiveSingleDataLocalDB<Profile> {
  @override
  String get boxName => 'profiles';

  @override
  String getId(Profile item) => item.id;

  @override
  Profile createValue() {
    final profile = Profile(
      id: uuid.v7(),
      // This will be replaced by supabase's auth.user auto generated uuid.
      userId: uuid.v7(),
      role: '',
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
      username: 'Anonymous',
    );
    return profile;
  }
}
