// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'comment.edit_log.dto.dart';

class CommentEditLogMapper extends ClassMapperBase<CommentEditLog> {
  CommentEditLogMapper._();

  static CommentEditLogMapper? _instance;
  static CommentEditLogMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CommentEditLogMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CommentEditLog';

  static String _$id(CommentEditLog v) => v.id;
  static const Field<CommentEditLog, String> _f$id = Field('id', _$id);
  static String _$oldBody(CommentEditLog v) => v.oldBody;
  static const Field<CommentEditLog, String> _f$oldBody =
      Field('oldBody', _$oldBody, key: r'old_body');
  static String _$newBody(CommentEditLog v) => v.newBody;
  static const Field<CommentEditLog, String> _f$newBody =
      Field('newBody', _$newBody, key: r'new_body');
  static String _$contentId(CommentEditLog v) => v.contentId;
  static const Field<CommentEditLog, String> _f$contentId =
      Field('contentId', _$contentId, key: r'content_id');

  @override
  final MappableFields<CommentEditLog> fields = const {
    #id: _f$id,
    #oldBody: _f$oldBody,
    #newBody: _f$newBody,
    #contentId: _f$contentId,
  };

  static CommentEditLog _instantiate(DecodingData data) {
    return CommentEditLog(
        id: data.dec(_f$id),
        oldBody: data.dec(_f$oldBody),
        newBody: data.dec(_f$newBody),
        contentId: data.dec(_f$contentId));
  }

  @override
  final Function instantiate = _instantiate;

  static CommentEditLog fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CommentEditLog>(map);
  }

  static CommentEditLog fromJson(String json) {
    return ensureInitialized().decodeJson<CommentEditLog>(json);
  }
}

mixin CommentEditLogMappable {
  String toJson() {
    return CommentEditLogMapper.ensureInitialized()
        .encodeJson<CommentEditLog>(this as CommentEditLog);
  }

  Map<String, dynamic> toMap() {
    return CommentEditLogMapper.ensureInitialized()
        .encodeMap<CommentEditLog>(this as CommentEditLog);
  }

  CommentEditLogCopyWith<CommentEditLog, CommentEditLog, CommentEditLog>
      get copyWith =>
          _CommentEditLogCopyWithImpl<CommentEditLog, CommentEditLog>(
              this as CommentEditLog, $identity, $identity);
  @override
  String toString() {
    return CommentEditLogMapper.ensureInitialized()
        .stringifyValue(this as CommentEditLog);
  }

  @override
  bool operator ==(Object other) {
    return CommentEditLogMapper.ensureInitialized()
        .equalsValue(this as CommentEditLog, other);
  }

  @override
  int get hashCode {
    return CommentEditLogMapper.ensureInitialized()
        .hashValue(this as CommentEditLog);
  }
}

extension CommentEditLogValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CommentEditLog, $Out> {
  CommentEditLogCopyWith<$R, CommentEditLog, $Out> get $asCommentEditLog =>
      $base.as((v, t, t2) => _CommentEditLogCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CommentEditLogCopyWith<$R, $In extends CommentEditLog, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? oldBody, String? newBody, String? contentId});
  CommentEditLogCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _CommentEditLogCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CommentEditLog, $Out>
    implements CommentEditLogCopyWith<$R, CommentEditLog, $Out> {
  _CommentEditLogCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CommentEditLog> $mapper =
      CommentEditLogMapper.ensureInitialized();
  @override
  $R call({String? id, String? oldBody, String? newBody, String? contentId}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (oldBody != null) #oldBody: oldBody,
        if (newBody != null) #newBody: newBody,
        if (contentId != null) #contentId: contentId
      }));
  @override
  CommentEditLog $make(CopyWithData data) => CommentEditLog(
      id: data.get(#id, or: $value.id),
      oldBody: data.get(#oldBody, or: $value.oldBody),
      newBody: data.get(#newBody, or: $value.newBody),
      contentId: data.get(#contentId, or: $value.contentId));

  @override
  CommentEditLogCopyWith<$R2, CommentEditLog, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _CommentEditLogCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
