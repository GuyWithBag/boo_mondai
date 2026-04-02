// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_profile.dart';

class UserProfileMapper extends ClassMapperBase<UserProfile> {
  UserProfileMapper._();

  static UserProfileMapper? _instance;
  static UserProfileMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserProfileMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserProfile';

  static String _$id(UserProfile v) => v.id;
  static const Field<UserProfile, String> _f$id = Field('id', _$id);
  static String _$userName(UserProfile v) => v.userName;
  static const Field<UserProfile, String> _f$userName =
      Field('userName', _$userName);
  static String _$role(UserProfile v) => v.role;
  static const Field<UserProfile, String> _f$role = Field('role', _$role);
  static String? _$avatarUrl(UserProfile v) => v.avatarUrl;
  static const Field<UserProfile, String> _f$avatarUrl =
      Field('avatarUrl', _$avatarUrl, opt: true);
  static String? _$targetLanguage(UserProfile v) => v.targetLanguage;
  static const Field<UserProfile, String> _f$targetLanguage =
      Field('targetLanguage', _$targetLanguage, opt: true);
  static DateTime _$createdAt(UserProfile v) => v.createdAt;
  static const Field<UserProfile, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);
  static String? _$userId(UserProfile v) => v.userId;
  static const Field<UserProfile, String> _f$userId =
      Field('userId', _$userId, opt: true);

  @override
  final MappableFields<UserProfile> fields = const {
    #id: _f$id,
    #userName: _f$userName,
    #role: _f$role,
    #avatarUrl: _f$avatarUrl,
    #targetLanguage: _f$targetLanguage,
    #createdAt: _f$createdAt,
    #userId: _f$userId,
  };

  static UserProfile _instantiate(DecodingData data) {
    return UserProfile(
        id: data.dec(_f$id),
        userName: data.dec(_f$userName),
        role: data.dec(_f$role),
        avatarUrl: data.dec(_f$avatarUrl),
        targetLanguage: data.dec(_f$targetLanguage),
        createdAt: data.dec(_f$createdAt),
        userId: data.dec(_f$userId));
  }

  @override
  final Function instantiate = _instantiate;

  static UserProfile fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserProfile>(map);
  }

  static UserProfile fromJson(String json) {
    return ensureInitialized().decodeJson<UserProfile>(json);
  }
}

mixin UserProfileMappable {
  String toJson() {
    return UserProfileMapper.ensureInitialized()
        .encodeJson<UserProfile>(this as UserProfile);
  }

  Map<String, dynamic> toMap() {
    return UserProfileMapper.ensureInitialized()
        .encodeMap<UserProfile>(this as UserProfile);
  }

  UserProfileCopyWith<UserProfile, UserProfile, UserProfile> get copyWith =>
      _UserProfileCopyWithImpl<UserProfile, UserProfile>(
          this as UserProfile, $identity, $identity);
  @override
  String toString() {
    return UserProfileMapper.ensureInitialized()
        .stringifyValue(this as UserProfile);
  }

  @override
  bool operator ==(Object other) {
    return UserProfileMapper.ensureInitialized()
        .equalsValue(this as UserProfile, other);
  }

  @override
  int get hashCode {
    return UserProfileMapper.ensureInitialized().hashValue(this as UserProfile);
  }
}

extension UserProfileValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserProfile, $Out> {
  UserProfileCopyWith<$R, UserProfile, $Out> get $asUserProfile =>
      $base.as((v, t, t2) => _UserProfileCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserProfileCopyWith<$R, $In extends UserProfile, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? userName,
      String? role,
      String? avatarUrl,
      String? targetLanguage,
      DateTime? createdAt,
      String? userId});
  UserProfileCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserProfileCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserProfile, $Out>
    implements UserProfileCopyWith<$R, UserProfile, $Out> {
  _UserProfileCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserProfile> $mapper =
      UserProfileMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? userName,
          String? role,
          Object? avatarUrl = $none,
          Object? targetLanguage = $none,
          DateTime? createdAt,
          Object? userId = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (userName != null) #userName: userName,
        if (role != null) #role: role,
        if (avatarUrl != $none) #avatarUrl: avatarUrl,
        if (targetLanguage != $none) #targetLanguage: targetLanguage,
        if (createdAt != null) #createdAt: createdAt,
        if (userId != $none) #userId: userId
      }));
  @override
  UserProfile $make(CopyWithData data) => UserProfile(
      id: data.get(#id, or: $value.id),
      userName: data.get(#userName, or: $value.userName),
      role: data.get(#role, or: $value.role),
      avatarUrl: data.get(#avatarUrl, or: $value.avatarUrl),
      targetLanguage: data.get(#targetLanguage, or: $value.targetLanguage),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      userId: data.get(#userId, or: $value.userId));

  @override
  UserProfileCopyWith<$R2, UserProfile, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _UserProfileCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
