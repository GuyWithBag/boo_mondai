import 'package:boo_mondai/lib.barrel.dart'
    show SupabaseRemoteDB, UserSettings, UserSettingsMapper;

/// Supabase table access for profile-scoped user settings.
class UserSettingsRemoteDB extends SupabaseRemoteDB<UserSettings> {
  @override
  String get tableName => 'user_settings';

  @override
  UserSettings Function(Map<String, dynamic>) get fromMap =>
      UserSettingsMapper.fromMap;

  @override
  Map<String, dynamic> toMap(UserSettings item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(UserSettings item) => {'id': item.id};

  @override
  String get upsertConflictTarget => 'id';
}
