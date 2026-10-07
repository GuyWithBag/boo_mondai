// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'profile.role.dto.dart';

class ProfileRoleMapper extends EnumMapper<ProfileRole> {
  ProfileRoleMapper._();

  static ProfileRoleMapper? _instance;
  static ProfileRoleMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ProfileRoleMapper._());
    }
    return _instance!;
  }

  static ProfileRole fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ProfileRole decode(dynamic value) {
    switch (value) {
      case 'user':
        return ProfileRole.user;
      case 'researcher':
        return ProfileRole.researcher;
      case 'appAdmin':
        return ProfileRole.appAdmin;
      case 'participant_chinese_a':
        return ProfileRole.participantChineseA;
      case 'participant_chinese_b':
        return ProfileRole.participantChineseB;
      case 'participant_japanese_a':
        return ProfileRole.participantJapaneseA;
      case 'participant_japanese_b':
        return ProfileRole.participantJapaneseB;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ProfileRole self) {
    switch (self) {
      case ProfileRole.user:
        return 'user';
      case ProfileRole.researcher:
        return 'researcher';
      case ProfileRole.appAdmin:
        return 'appAdmin';
      case ProfileRole.participantChineseA:
        return 'participant_chinese_a';
      case ProfileRole.participantChineseB:
        return 'participant_chinese_b';
      case ProfileRole.participantJapaneseA:
        return 'participant_japanese_a';
      case ProfileRole.participantJapaneseB:
        return 'participant_japanese_b';
    }
  }
}

extension ProfileRoleMapperExtension on ProfileRole {
  dynamic toValue() {
    ProfileRoleMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ProfileRole>(this);
  }
}

