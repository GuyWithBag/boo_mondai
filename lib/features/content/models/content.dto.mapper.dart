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
      ContentTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Content';

  static String _$id(Content v) => v.id;
  static const Field<Content, String> _f$id = Field('id', _$id);
  static String _$profileId(Content v) => v.profileId;
  static const Field<Content, String> _f$profileId =
      Field('profileId', _$profileId, key: r'profile_id');
  static DateTime _$createdAt(Content v) => v.createdAt;
  static const Field<Content, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static DateTime _$updatedAt(Content v) => v.updatedAt;
  static const Field<Content, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, key: r'updated_at');
  static bool _$hasVotes(Content v) => v.hasVotes;
  static const Field<Content, bool> _f$hasVotes =
      Field('hasVotes', _$hasVotes, key: r'has_votes', opt: true, def: true);
  static String? _$parentContentId(Content v) => v.parentContentId;
  static const Field<Content, String> _f$parentContentId = Field(
      'parentContentId', _$parentContentId,
      key: r'parent_content_id', opt: true);
  static ContentType _$type(Content v) => v.type;
  static const Field<Content, ContentType> _f$type = Field('type', _$type);
  static DateTime? _$deletedAt(Content v) => v.deletedAt;
  static const Field<Content, DateTime> _f$deletedAt =
      Field('deletedAt', _$deletedAt, key: r'deleted_at', opt: true);
  static DateTime? _$purgeAfter(Content v) => v.purgeAfter;
  static const Field<Content, DateTime> _f$purgeAfter =
      Field('purgeAfter', _$purgeAfter, key: r'purge_after', opt: true);

  @override
  final MappableFields<Content> fields = const {
    #id: _f$id,
    #profileId: _f$profileId,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #hasVotes: _f$hasVotes,
    #parentContentId: _f$parentContentId,
    #type: _f$type,
    #deletedAt: _f$deletedAt,
    #purgeAfter: _f$purgeAfter,
  };

  static Content _instantiate(DecodingData data) {
    return Content(
        id: data.dec(_f$id),
        profileId: data.dec(_f$profileId),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt),
        hasVotes: data.dec(_f$hasVotes),
        parentContentId: data.dec(_f$parentContentId),
        type: data.dec(_f$type),
        deletedAt: data.dec(_f$deletedAt),
        purgeAfter: data.dec(_f$purgeAfter));
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
      String? profileId,
      DateTime? createdAt,
      DateTime? updatedAt,
      bool? hasVotes,
      String? parentContentId,
      ContentType? type,
      DateTime? deletedAt,
      DateTime? purgeAfter});
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
          String? profileId,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? hasVotes,
          Object? parentContentId = $none,
          ContentType? type,
          Object? deletedAt = $none,
          Object? purgeAfter = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (profileId != null) #profileId: profileId,
        if (createdAt != null) #createdAt: createdAt,
        if (updatedAt != null) #updatedAt: updatedAt,
        if (hasVotes != null) #hasVotes: hasVotes,
        if (parentContentId != $none) #parentContentId: parentContentId,
        if (type != null) #type: type,
        if (deletedAt != $none) #deletedAt: deletedAt,
        if (purgeAfter != $none) #purgeAfter: purgeAfter
      }));
  @override
  Content $make(CopyWithData data) => Content(
      id: data.get(#id, or: $value.id),
      profileId: data.get(#profileId, or: $value.profileId),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt),
      hasVotes: data.get(#hasVotes, or: $value.hasVotes),
      parentContentId: data.get(#parentContentId, or: $value.parentContentId),
      type: data.get(#type, or: $value.type),
      deletedAt: data.get(#deletedAt, or: $value.deletedAt),
      purgeAfter: data.get(#purgeAfter, or: $value.purgeAfter));

  @override
  ContentCopyWith<$R2, Content, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _ContentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
