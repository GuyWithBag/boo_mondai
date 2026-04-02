// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'cached_profile.dart';

class CachedProfileMapper extends ClassMapperBase<CachedProfile> {
  CachedProfileMapper._();

  static CachedProfileMapper? _instance;
  static CachedProfileMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CachedProfileMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CachedProfile';

  static String _$id(CachedProfile v) => v.id;
  static const Field<CachedProfile, String> _f$id = Field('id', _$id);
  static String _$userName(CachedProfile v) => v.userName;
  static const Field<CachedProfile, String> _f$userName =
      Field('userName', _$userName);
  static String? _$avatarUrl(CachedProfile v) => v.avatarUrl;
  static const Field<CachedProfile, String> _f$avatarUrl =
      Field('avatarUrl', _$avatarUrl, opt: true);
  static DateTime _$createdAt(CachedProfile v) => v.createdAt;
  static const Field<CachedProfile, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);

  @override
  final MappableFields<CachedProfile> fields = const {
    #id: _f$id,
    #userName: _f$userName,
    #avatarUrl: _f$avatarUrl,
    #createdAt: _f$createdAt,
  };

  static CachedProfile _instantiate(DecodingData data) {
    return CachedProfile(
        id: data.dec(_f$id),
        userName: data.dec(_f$userName),
        avatarUrl: data.dec(_f$avatarUrl),
        createdAt: data.dec(_f$createdAt));
  }

  @override
  final Function instantiate = _instantiate;

  static CachedProfile fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CachedProfile>(map);
  }

  static CachedProfile fromJson(String json) {
    return ensureInitialized().decodeJson<CachedProfile>(json);
  }
}

mixin CachedProfileMappable {
  String toJson() {
    return CachedProfileMapper.ensureInitialized()
        .encodeJson<CachedProfile>(this as CachedProfile);
  }

  Map<String, dynamic> toMap() {
    return CachedProfileMapper.ensureInitialized()
        .encodeMap<CachedProfile>(this as CachedProfile);
  }

  CachedProfileCopyWith<CachedProfile, CachedProfile, CachedProfile>
      get copyWith => _CachedProfileCopyWithImpl<CachedProfile, CachedProfile>(
          this as CachedProfile, $identity, $identity);
  @override
  String toString() {
    return CachedProfileMapper.ensureInitialized()
        .stringifyValue(this as CachedProfile);
  }

  @override
  bool operator ==(Object other) {
    return CachedProfileMapper.ensureInitialized()
        .equalsValue(this as CachedProfile, other);
  }

  @override
  int get hashCode {
    return CachedProfileMapper.ensureInitialized()
        .hashValue(this as CachedProfile);
  }
}

extension CachedProfileValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CachedProfile, $Out> {
  CachedProfileCopyWith<$R, CachedProfile, $Out> get $asCachedProfile =>
      $base.as((v, t, t2) => _CachedProfileCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CachedProfileCopyWith<$R, $In extends CachedProfile, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id, String? userName, String? avatarUrl, DateTime? createdAt});
  CachedProfileCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CachedProfileCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CachedProfile, $Out>
    implements CachedProfileCopyWith<$R, CachedProfile, $Out> {
  _CachedProfileCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CachedProfile> $mapper =
      CachedProfileMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? userName,
          Object? avatarUrl = $none,
          DateTime? createdAt}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (userName != null) #userName: userName,
        if (avatarUrl != $none) #avatarUrl: avatarUrl,
        if (createdAt != null) #createdAt: createdAt
      }));
  @override
  CachedProfile $make(CopyWithData data) => CachedProfile(
      id: data.get(#id, or: $value.id),
      userName: data.get(#userName, or: $value.userName),
      avatarUrl: data.get(#avatarUrl, or: $value.avatarUrl),
      createdAt: data.get(#createdAt, or: $value.createdAt));

  @override
  CachedProfileCopyWith<$R2, CachedProfile, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _CachedProfileCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
