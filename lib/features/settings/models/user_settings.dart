import 'package:boo_mondai/lib.barrel.dart'
    show IdentifiableEntity, TimestampedEntity, UserOwnedEntity, uuid;
import 'package:dart_mappable/dart_mappable.dart';

part 'user_settings.mapper.dart';

@MappableClass()
class UserSettings
    with
        IdentifiableEntity,
        TimestampedEntity,
        UserOwnedEntity,
        UserSettingsMappable {
  const UserSettings({
    required this.id,
    required this.profileId,
    required this.preferences,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  final String id;
  @override
  final String profileId;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Complete persisted setting values, keyed by [SettingPath.value].
  final Map<String, dynamic> preferences;

  factory UserSettings.defaults({required String profileId}) {
    final now = DateTime.now();
    return UserSettings(
      id: uuid.v7(),
      profileId: profileId,
      preferences: const {},
      createdAt: now,
      updatedAt: now,
    );
  }
}
