// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'cached_media.dart';

class CachedMediaMapper extends ClassMapperBase<CachedMedia> {
  CachedMediaMapper._();

  static CachedMediaMapper? _instance;
  static CachedMediaMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CachedMediaMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CachedMedia';

  static Uint8List _$bytes(CachedMedia v) => v.bytes;
  static const Field<CachedMedia, Uint8List> _f$bytes = Field('bytes', _$bytes);
  static String _$path(CachedMedia v) => v.path;
  static const Field<CachedMedia, String> _f$path = Field('path', _$path);
  static String _$profileId(CachedMedia v) => v.profileId;
  static const Field<CachedMedia, String> _f$profileId =
      Field('profileId', _$profileId, key: r'profile_id');

  @override
  final MappableFields<CachedMedia> fields = const {
    #bytes: _f$bytes,
    #path: _f$path,
    #profileId: _f$profileId,
  };

  static CachedMedia _instantiate(DecodingData data) {
    return CachedMedia(
        bytes: data.dec(_f$bytes),
        path: data.dec(_f$path),
        profileId: data.dec(_f$profileId));
  }

  @override
  final Function instantiate = _instantiate;

  static CachedMedia fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CachedMedia>(map);
  }

  static CachedMedia fromJson(String json) {
    return ensureInitialized().decodeJson<CachedMedia>(json);
  }
}

mixin CachedMediaMappable {
  String toJson() {
    return CachedMediaMapper.ensureInitialized()
        .encodeJson<CachedMedia>(this as CachedMedia);
  }

  Map<String, dynamic> toMap() {
    return CachedMediaMapper.ensureInitialized()
        .encodeMap<CachedMedia>(this as CachedMedia);
  }

  CachedMediaCopyWith<CachedMedia, CachedMedia, CachedMedia> get copyWith =>
      _CachedMediaCopyWithImpl<CachedMedia, CachedMedia>(
          this as CachedMedia, $identity, $identity);
  @override
  String toString() {
    return CachedMediaMapper.ensureInitialized()
        .stringifyValue(this as CachedMedia);
  }

  @override
  bool operator ==(Object other) {
    return CachedMediaMapper.ensureInitialized()
        .equalsValue(this as CachedMedia, other);
  }

  @override
  int get hashCode {
    return CachedMediaMapper.ensureInitialized().hashValue(this as CachedMedia);
  }
}

extension CachedMediaValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CachedMedia, $Out> {
  CachedMediaCopyWith<$R, CachedMedia, $Out> get $asCachedMedia =>
      $base.as((v, t, t2) => _CachedMediaCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CachedMediaCopyWith<$R, $In extends CachedMedia, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({Uint8List? bytes, String? path, String? profileId});
  CachedMediaCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CachedMediaCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CachedMedia, $Out>
    implements CachedMediaCopyWith<$R, CachedMedia, $Out> {
  _CachedMediaCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CachedMedia> $mapper =
      CachedMediaMapper.ensureInitialized();
  @override
  $R call({Uint8List? bytes, String? path, String? profileId}) =>
      $apply(FieldCopyWithData({
        if (bytes != null) #bytes: bytes,
        if (path != null) #path: path,
        if (profileId != null) #profileId: profileId
      }));
  @override
  CachedMedia $make(CopyWithData data) => CachedMedia(
      bytes: data.get(#bytes, or: $value.bytes),
      path: data.get(#path, or: $value.path),
      profileId: data.get(#profileId, or: $value.profileId));

  @override
  CachedMediaCopyWith<$R2, CachedMedia, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _CachedMediaCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
