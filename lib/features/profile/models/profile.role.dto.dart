import 'package:dart_mappable/dart_mappable.dart';

part 'profile.role.dto.mapper.dart';

@MappableEnum()
enum ProfileRole {
  @MappableValue('user')
  user('user'),

  @MappableValue('appAdmin')
  appAdmin('appAdmin');

  const ProfileRole(this.value);

  final String value;

  static ProfileRole fromString(String? value) {
    final normalized = value?.trim().toLowerCase();

    return ProfileRole.values.firstWhere(
      (role) => role.value == normalized,
      orElse: () => ProfileRole.user,
    );
  }
}
