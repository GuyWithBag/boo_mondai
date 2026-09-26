// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'comment.dto.dart';

class CommentMapper extends ClassMapperBase<Comment> {
  CommentMapper._();

  static CommentMapper? _instance;
  static CommentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CommentMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Comment';

  static String _$id(Comment v) => v.id;
  static const Field<Comment, String> _f$id = Field('id', _$id);
  static String _$body(Comment v) => v.body;
  static const Field<Comment, String> _f$body = Field('body', _$body);
  static String _$contentId(Comment v) => v.contentId;
  static const Field<Comment, String> _f$contentId =
      Field('contentId', _$contentId, key: r'content_id');
  static DateTime _$deletedAt(Comment v) => v.deletedAt;
  static const Field<Comment, DateTime> _f$deletedAt =
      Field('deletedAt', _$deletedAt, key: r'deleted_at');

  @override
  final MappableFields<Comment> fields = const {
    #id: _f$id,
    #body: _f$body,
    #contentId: _f$contentId,
    #deletedAt: _f$deletedAt,
  };

  static Comment _instantiate(DecodingData data) {
    return Comment(
        id: data.dec(_f$id),
        body: data.dec(_f$body),
        contentId: data.dec(_f$contentId),
        deletedAt: data.dec(_f$deletedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static Comment fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Comment>(map);
  }

  static Comment fromJson(String json) {
    return ensureInitialized().decodeJson<Comment>(json);
  }
}

mixin CommentMappable {
  String toJson() {
    return CommentMapper.ensureInitialized()
        .encodeJson<Comment>(this as Comment);
  }

  Map<String, dynamic> toMap() {
    return CommentMapper.ensureInitialized()
        .encodeMap<Comment>(this as Comment);
  }

  CommentCopyWith<Comment, Comment, Comment> get copyWith =>
      _CommentCopyWithImpl<Comment, Comment>(
          this as Comment, $identity, $identity);
  @override
  String toString() {
    return CommentMapper.ensureInitialized().stringifyValue(this as Comment);
  }

  @override
  bool operator ==(Object other) {
    return CommentMapper.ensureInitialized()
        .equalsValue(this as Comment, other);
  }

  @override
  int get hashCode {
    return CommentMapper.ensureInitialized().hashValue(this as Comment);
  }
}

extension CommentValueCopy<$R, $Out> on ObjectCopyWith<$R, Comment, $Out> {
  CommentCopyWith<$R, Comment, $Out> get $asComment =>
      $base.as((v, t, t2) => _CommentCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CommentCopyWith<$R, $In extends Comment, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? body, String? contentId, DateTime? deletedAt});
  CommentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CommentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Comment, $Out>
    implements CommentCopyWith<$R, Comment, $Out> {
  _CommentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Comment> $mapper =
      CommentMapper.ensureInitialized();
  @override
  $R call({String? id, String? body, String? contentId, DateTime? deletedAt}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (body != null) #body: body,
        if (contentId != null) #contentId: contentId,
        if (deletedAt != null) #deletedAt: deletedAt
      }));
  @override
  Comment $make(CopyWithData data) => Comment(
      id: data.get(#id, or: $value.id),
      body: data.get(#body, or: $value.body),
      contentId: data.get(#contentId, or: $value.contentId),
      deletedAt: data.get(#deletedAt, or: $value.deletedAt));

  @override
  CommentCopyWith<$R2, Comment, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _CommentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
