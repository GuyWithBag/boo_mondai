// Contains Cache of profiles and source profiles for deck type

import 'package:boo_mondai/models/models.barrel.dart';

import 'hive_repository.dart';

class UserDeckProgressRepository extends HiveRepository<UserDeckProgress> {
  @override
  String get boxName => 'user_deck_progress_box';

  @override
  String getId(UserDeckProgress item) => item.id;
}
