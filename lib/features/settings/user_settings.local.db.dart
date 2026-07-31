import 'package:boo_mondai/lib.barrel.dart' show HiveLocalDB, UserSettings;

class UserSettingsLocalDB extends HiveLocalDB<UserSettings> {
  @override
  String get boxName => 'user_settings';

  @override
  Map<String, Object?> primaryKeyFromItem(UserSettings item) => {'id': item.id};

  /// Returns the settings row for [profileId], or null if none exists.
  UserSettings? getByProfileId(String profileId) {
    final rows = selectMany(
      where: (row) => row.profileId == profileId,
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first;
  }

  /// Returns existing settings for [profileId], or creates and persists
  /// a defaults row if none exists.
  UserSettings getOrCreateByProfileId(String profileId) {
    final existing = getByProfileId(profileId);
    if (existing != null) return existing;

    final defaults = UserSettings.defaults(profileId: profileId);
    upsert(defaults); // fire-and-forget, errors surfaced via guard()
    return defaults;
  }
}
