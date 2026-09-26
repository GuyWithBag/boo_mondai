// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'gay.dart';

class GayMapper extends ClassMapperBase<Gay> {
  GayMapper._();

  static GayMapper? _instance;
  static GayMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = GayMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Gay';

  static String _$profileId(Gay v) => v.profileId;
  static const Field<Gay, String> _f$profileId =
      Field('profileId', _$profileId, key: r'profile_id');
  static Uint8List _$bytes(Gay v) => v.bytes;
  static const Field<Gay, Uint8List> _f$bytes = Field('bytes', _$bytes);
  static String _$filePath(Gay v) => v.filePath;
  static const Field<Gay, String> _f$filePath =
      Field('filePath', _$filePath, key: r'file_path');

  @override
  final MappableFields<Gay> fields = const {
    #profileId: _f$profileId,
    #bytes: _f$bytes,
    #filePath: _f$filePath,
  };

  static Gay _instantiate(DecodingData data) {
    return Gay(
        profileId: data.dec(_f$profileId),
        bytes: data.dec(_f$bytes),
        filePath: data.dec(_f$filePath));
  }

  @override
  final Function instantiate = _instantiate;

  static Gay fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Gay>(map);
  }

  static Gay fromJson(String json) {
    return ensureInitialized().decodeJson<Gay>(json);
  }
}

mixin GayMappable {
  String toJson() {
    return GayMapper.ensureInitialized().encodeJson<Gay>(this as Gay);
  }

  Map<String, dynamic> toMap() {
    return GayMapper.ensureInitialized().encodeMap<Gay>(this as Gay);
  }

  GayCopyWith<Gay, Gay, Gay> get copyWith =>
      _GayCopyWithImpl<Gay, Gay>(this as Gay, $identity, $identity);
  @override
  String toString() {
    return GayMapper.ensureInitialized().stringifyValue(this as Gay);
  }

  @override
  bool operator ==(Object other) {
    return GayMapper.ensureInitialized().equalsValue(this as Gay, other);
  }

  @override
  int get hashCode {
    return GayMapper.ensureInitialized().hashValue(this as Gay);
  }
}

extension GayValueCopy<$R, $Out> on ObjectCopyWith<$R, Gay, $Out> {
  GayCopyWith<$R, Gay, $Out> get $asGay =>
      $base.as((v, t, t2) => _GayCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class GayCopyWith<$R, $In extends Gay, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? profileId, Uint8List? bytes, String? filePath});
  GayCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _GayCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Gay, $Out>
    implements GayCopyWith<$R, Gay, $Out> {
  _GayCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Gay> $mapper = GayMapper.ensureInitialized();
  @override
  $R call({String? profileId, Uint8List? bytes, String? filePath}) =>
      $apply(FieldCopyWithData({
        if (profileId != null) #profileId: profileId,
        if (bytes != null) #bytes: bytes,
        if (filePath != null) #filePath: filePath
      }));
  @override
  Gay $make(CopyWithData data) => Gay(
      profileId: data.get(#profileId, or: $value.profileId),
      bytes: data.get(#bytes, or: $value.bytes),
      filePath: data.get(#filePath, or: $value.filePath));

  @override
  GayCopyWith<$R2, Gay, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _GayCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
