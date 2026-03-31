// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/user_profile_repository.dart
// PURPOSE: Hive CRUD for UserProfile — single-record store for the local user's profile
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:hive_ce/hive.dart';
import '../models/user_profile.dart';

class UserProfileRepository {
  static const String boxName = 'user_profile_box';
  static const String _profileKey = 'profile';

  Box<UserProfile> get _box => Hive.box<UserProfile>(boxName);

  UserProfile? get() => _box.get(_profileKey);

  Future<void> save(UserProfile profile) => _box.put(_profileKey, profile);

  Future<void> delete() => _box.delete(_profileKey);

  Future<void> clear() => _box.clear();
}
