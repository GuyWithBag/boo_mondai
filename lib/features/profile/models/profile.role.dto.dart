import 'package:dart_mappable/dart_mappable.dart';

part 'profile.role.dto.mapper.dart';

@MappableEnum()
enum ProfileRole {
  @MappableValue('user')
  user('user'),
  @MappableValue('researcher')
  researcher('researcher'),
  @MappableValue('appAdmin')
  appAdmin('appAdmin'),
  @MappableValue('participant_chinese_a')
  participantChineseA('participant_chinese_a'),
  @MappableValue('participant_chinese_b')
  participantChineseB('participant_chinese_b'),
  @MappableValue('participant_japanese_a')
  participantJapaneseA('participant_japanese_a'),
  @MappableValue('participant_japanese_b')
  participantJapaneseB('participant_japanese_b');

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
