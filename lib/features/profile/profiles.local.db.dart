import 'package:boo_mondai/lib.barrel.dart' show Profile, HiveLocalDB;

class ProfilesLocalDB extends HiveLocalDB<Profile> {
  @override
  String get boxName => 'profiles';

  @override
  Map<String, Object?> primaryKeyFromItem(Profile item) => {'id': item.id};

  Profile? selectByUserId(String userId) => box.get(userId);
}
