// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
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
      case r'user':
        return ProfileRole.user;
      case r'researcher':
        return ProfileRole.researcher;
      case r'admin':
        return ProfileRole.admin;
      case r'participant_a':
        return ProfileRole.participantA;
      case r'participant_b':
        return ProfileRole.participantB;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ProfileRole self) {
    switch (self) {
      case ProfileRole.user:
        return r'user';
      case ProfileRole.researcher:
        return r'researcher';
      case ProfileRole.admin:
        return r'admin';
      case ProfileRole.participantA:
        return r'participant_a';
      case ProfileRole.participantB:
        return r'participant_b';
    }
  }
}

extension ProfileRoleMapperExtension on ProfileRole {
  String toValue() {
    ProfileRoleMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ProfileRole>(this) as String;
  }
}
