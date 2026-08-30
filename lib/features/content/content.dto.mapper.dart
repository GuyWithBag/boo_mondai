// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'content.dto.dart';

class ContentMapper extends ClassMapperBase<Content> {
  ContentMapper._();

  static ContentMapper? _instance;
  static ContentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ContentMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Content';

  static String _$id(Content v) => v.id;
  static const Field<Content, String> _f$id = Field('id', _$id);
  static String _$profiledId(Content v) => v.profiledId;
  static const Field<Content, String> _f$profiledId =
      Field('profiledId', _$profiledId, key: r'profiled_id');
  static DateTime _$createdAt(Content v) => v.createdAt;
  static const Field<Content, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static DateTime _$updatedAt(Content v) => v.updatedAt;
  static const Field<Content, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, key: r'updated_at');

  @override
  final MappableFields<Content> fields = const {
    #id: _f$id,
    #profiledId: _f$profiledId,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
  };

  static Content _instantiate(DecodingData data) {
    return Content(
        id: data.dec(_f$id),
        profiledId: data.dec(_f$profiledId),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static Content fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Content>(map);
  }

  static Content fromJson(String json) {
    return ensureInitialized().decodeJson<Content>(json);
  }
}

mixin ContentMappable {
  String toJson() {
    return ContentMapper.ensureInitialized()
        .encodeJson<Content>(this as Content);
  }

  Map<String, dynamic> toMap() {
    return ContentMapper.ensureInitialized()
        .encodeMap<Content>(this as Content);
  }

  ContentCopyWith<Content, Content, Content> get copyWith =>
      _ContentCopyWithImpl<Content, Content>(
          this as Content, $identity, $identity);
  @override
  String toString() {
    return ContentMapper.ensureInitialized().stringifyValue(this as Content);
  }

  @override
  bool operator ==(Object other) {
    return ContentMapper.ensureInitialized()
        .equalsValue(this as Content, other);
  }

  @override
  int get hashCode {
    return ContentMapper.ensureInitialized().hashValue(this as Content);
  }
}

extension ContentValueCopy<$R, $Out> on ObjectCopyWith<$R, Content, $Out> {
  ContentCopyWith<$R, Content, $Out> get $asContent =>
      $base.as((v, t, t2) => _ContentCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ContentCopyWith<$R, $In extends Content, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? profiledId,
      DateTime? createdAt,
      DateTime? updatedAt});
  ContentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ContentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Content, $Out>
    implements ContentCopyWith<$R, Content, $Out> {
  _ContentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Content> $mapper =
      ContentMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? profiledId,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (profiledId != null) #profiledId: profiledId,
        if (createdAt != null) #createdAt: createdAt,
        if (updatedAt != null) #updatedAt: updatedAt
      }));
  @override
  Content $make(CopyWithData data) => Content(
      id: data.get(#id, or: $value.id),
      profiledId: data.get(#profiledId, or: $value.profiledId),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt));

  @override
  ContentCopyWith<$R2, Content, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ContentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
