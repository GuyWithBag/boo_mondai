import 'package:boo_mondai/lib.barrel.dart' show HiveLocalDB, UserSettings;

class UserSettingsLocalDB extends HiveLocalDB<UserSettings> {
  @override
  String get boxName => 'user_settings';

  @override
  Map<String, Object?> primaryKeyFromItem(UserSettings item) => {'id': item.id};

  /// Returns the settings row for [userId], or null if none exists.
  UserSettings? getByUserId(String userId) {
    final rows = selectMany(where: (row) => row.userId == userId, limit: 1);
    return rows.isEmpty ? null : rows.first;
  }

  /// Returns existing settings for [userId], or creates and persists
  /// a defaults row if none exists.
  UserSettings getOrCreateByUserId(String userId) {
    final existing = getByUserId(userId);
    if (existing != null) return existing;

    final defaults = UserSettings.defaults(userId: userId);
    upsert(defaults); // fire-and-forget, errors surfaced via guard()
    return defaults;
  }
}
