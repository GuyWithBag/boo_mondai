// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'profile.dto.dart';

class ProfileMapper extends ClassMapperBase<Profile> {
  ProfileMapper._();

  static ProfileMapper? _instance;
  static ProfileMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ProfileMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Profile';

  static String _$id(Profile v) => v.id;
  static const Field<Profile, String> _f$id = Field('id', _$id);
  static String _$username(Profile v) => v.username;
  static const Field<Profile, String> _f$username =
      Field('username', _$username);
  static String _$role(Profile v) => v.role;
  static const Field<Profile, String> _f$role = Field('role', _$role);
  static String? _$avatarUrl(Profile v) => v.avatarUrl;
  static const Field<Profile, String> _f$avatarUrl =
      Field('avatarUrl', _$avatarUrl, key: r'avatar_url', opt: true);
  static DateTime _$createdAt(Profile v) => v.createdAt;
  static const Field<Profile, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static String _$userId(Profile v) => v.userId;
  static const Field<Profile, String> _f$userId =
      Field('userId', _$userId, key: r'user_id');
  static DateTime _$updatedAt(Profile v) => v.updatedAt;
  static const Field<Profile, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, key: r'updated_at');
  static bool _$isAnonymous(Profile v) => v.isAnonymous;
  static const Field<Profile, bool> _f$isAnonymous = Field(
      'isAnonymous', _$isAnonymous,
      key: r'is_anonymous', opt: true, def: true);

  @override
  final MappableFields<Profile> fields = const {
    #id: _f$id,
    #username: _f$username,
    #role: _f$role,
    #avatarUrl: _f$avatarUrl,
    #createdAt: _f$createdAt,
    #userId: _f$userId,
    #updatedAt: _f$updatedAt,
    #isAnonymous: _f$isAnonymous,
  };

  static Profile _instantiate(DecodingData data) {
    return Profile(
        id: data.dec(_f$id),
        username: data.dec(_f$username),
        role: data.dec(_f$role),
        avatarUrl: data.dec(_f$avatarUrl),
        createdAt: data.dec(_f$createdAt),
        userId: data.dec(_f$userId),
        updatedAt: data.dec(_f$updatedAt),
        isAnonymous: data.dec(_f$isAnonymous));
  }

  @override
  final Function instantiate = _instantiate;

  static Profile fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Profile>(map);
  }

  static Profile fromJson(String json) {
    return ensureInitialized().decodeJson<Profile>(json);
  }
}

mixin ProfileMappable {
  String toJson() {
    return ProfileMapper.ensureInitialized()
        .encodeJson<Profile>(this as Profile);
  }

  Map<String, dynamic> toMap() {
    return ProfileMapper.ensureInitialized()
        .encodeMap<Profile>(this as Profile);
  }

  ProfileCopyWith<Profile, Profile, Profile> get copyWith =>
      _ProfileCopyWithImpl<Profile, Profile>(
          this as Profile, $identity, $identity);
  @override
  String toString() {
    return ProfileMapper.ensureInitialized().stringifyValue(this as Profile);
  }

  @override
  bool operator ==(Object other) {
    return ProfileMapper.ensureInitialized()
        .equalsValue(this as Profile, other);
  }

  @override
  int get hashCode {
    return ProfileMapper.ensureInitialized().hashValue(this as Profile);
  }
}

extension ProfileValueCopy<$R, $Out> on ObjectCopyWith<$R, Profile, $Out> {
  ProfileCopyWith<$R, Profile, $Out> get $asProfile =>
      $base.as((v, t, t2) => _ProfileCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ProfileCopyWith<$R, $In extends Profile, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? username,
      String? role,
      String? avatarUrl,
      DateTime? createdAt,
      String? userId,
      DateTime? updatedAt,
      bool? isAnonymous});
  ProfileCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ProfileCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Profile, $Out>
    implements ProfileCopyWith<$R, Profile, $Out> {
  _ProfileCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Profile> $mapper =
      ProfileMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? username,
          String? role,
          Object? avatarUrl = $none,
          DateTime? createdAt,
          String? userId,
          DateTime? updatedAt,
          bool? isAnonymous}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (username != null) #username: username,
        if (role != null) #role: role,
        if (avatarUrl != $none) #avatarUrl: avatarUrl,
        if (createdAt != null) #createdAt: createdAt,
        if (userId != null) #userId: userId,
        if (updatedAt != null) #updatedAt: updatedAt,
        if (isAnonymous != null) #isAnonymous: isAnonymous
      }));
  @override
  Profile $make(CopyWithData data) => Profile(
      id: data.get(#id, or: $value.id),
      username: data.get(#username, or: $value.username),
      role: data.get(#role, or: $value.role),
      avatarUrl: data.get(#avatarUrl, or: $value.avatarUrl),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      userId: data.get(#userId, or: $value.userId),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt),
      isAnonymous: data.get(#isAnonymous, or: $value.isAnonymous));

  @override
  ProfileCopyWith<$R2, Profile, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ProfileCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
