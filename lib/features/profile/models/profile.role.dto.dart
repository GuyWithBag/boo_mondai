import 'package:dart_mappable/dart_mappable.dart';

part 'profile.role.dto.mapper.dart';

@MappableEnum()
enum ProfileRole {
  user('user'),
  researcher('researcher'),
  admin('admin'),
  participantA('participant_a'),
  participantB('participant_b');

  const ProfileRole(this.value);

  final String value;

  static ProfileRole fromString(String? value) {
    final normalized = value?.trim().toLowerCase();

    return ProfileRole.values.firstWhere(
      (role) => role.value == normalized,
      orElse: () => ProfileRole.user,
    );
  }

  static bool isParticipant(ProfileRole role) {
    return role.value.startsWith('participant');
  }
}
