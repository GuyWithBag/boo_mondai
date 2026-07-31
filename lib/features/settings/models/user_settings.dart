import 'package:boo_mondai/lib.barrel.dart'
    show IdentifiableEntity, TimestampedEntity, UserOwnedEntity, Setting, uuid;
import 'package:dart_mappable/dart_mappable.dart';
part 'user_settings.mapper.dart';

/// Single settings row per user, stored as a typed key-value map.
///
/// Add new settings via [Setting] constants — no model changes required.
@MappableClass()
class UserSettings
    with
        IdentifiableEntity,
        TimestampedEntity,
        UserOwnedEntity,
        UserSettingsMappable {
  const UserSettings({
    required this.id,
    required this.userId,
    required this.preferences,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  final String id;
  @override
  final String userId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// All user preferences as a flat key-value map.
  /// Keys follow the `namespace/key` convention defined on [Setting].
  final Map<String, dynamic> preferences;

  // ---------------------------------------------------------------------------
  // Typed accessors
  // ---------------------------------------------------------------------------

  /// Returns the current value for [setting], or its default if absent.
  T get<T>(Setting<T> setting) =>
      preferences[setting.key] as T? ?? setting.defaultValue;

  /// Returns a new [UserSettings] with [value] written for [setting].
  UserSettings set<T>(Setting<T> setting, T value) =>
      copyWith(preferences: {...preferences, setting.key: value});

  // ---------------------------------------------------------------------------
  // Factory
  // ---------------------------------------------------------------------------

  /// Creates a defaults row for [userId] with an empty preferences map.
  factory UserSettings.defaults({required String userId}) {
    final now = DateTime.now();
    return UserSettings(
      id: uuid.v7(),
      userId: userId,
      preferences: const {},
      createdAt: now,
      updatedAt: now,
    );
  }
}
