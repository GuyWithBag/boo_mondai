import 'package:boo_mondai/lib.barrel.dart' show HiveLocalDB, UserSettings;

/// Hive persistence for profile-scoped user settings rows.
class UserSettingsLocalDB extends HiveLocalDB<UserSettings> {
  @override
  String get boxName => 'user_settings';

  @override
  Map<String, Object?> primaryKeyFromItem(UserSettings item) => {'id': item.id};

  /// Returns one settings row by owner `userId`.
  UserSettings? getByUserId(String userId) {
    final rows = selectMany(where: (row) => row.userId == userId, limit: 1);
    return rows.isEmpty ? null : rows.first;
  }
}
