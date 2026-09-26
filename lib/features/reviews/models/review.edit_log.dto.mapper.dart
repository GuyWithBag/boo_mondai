// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'review.edit_log.dto.dart';

class ReviewEditLogMapper extends ClassMapperBase<ReviewEditLog> {
  ReviewEditLogMapper._();

  static ReviewEditLogMapper? _instance;
  static ReviewEditLogMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReviewEditLogMapper._());
      CommentEditLogMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ReviewEditLog';

  static String _$id(ReviewEditLog v) => v.id;
  static const Field<ReviewEditLog, String> _f$id = Field('id', _$id);
  static String _$contentId(ReviewEditLog v) => v.contentId;
  static const Field<ReviewEditLog, String> _f$contentId =
      Field('contentId', _$contentId, key: r'content_id');
  static String _$oldTitle(ReviewEditLog v) => v.oldTitle;
  static const Field<ReviewEditLog, String> _f$oldTitle =
      Field('oldTitle', _$oldTitle, key: r'old_title');
  static String _$newTitle(ReviewEditLog v) => v.newTitle;
  static const Field<ReviewEditLog, String> _f$newTitle =
      Field('newTitle', _$newTitle, key: r'new_title');
  static String _$oldBody(ReviewEditLog v) => v.oldBody;
  static const Field<ReviewEditLog, String> _f$oldBody =
      Field('oldBody', _$oldBody, key: r'old_body');
  static String _$newBody(ReviewEditLog v) => v.newBody;
  static const Field<ReviewEditLog, String> _f$newBody =
      Field('newBody', _$newBody, key: r'new_body');

  @override
  final MappableFields<ReviewEditLog> fields = const {
    #id: _f$id,
    #contentId: _f$contentId,
    #oldTitle: _f$oldTitle,
    #newTitle: _f$newTitle,
    #oldBody: _f$oldBody,
    #newBody: _f$newBody,
  };

  static ReviewEditLog _instantiate(DecodingData data) {
    return ReviewEditLog(
        id: data.dec(_f$id),
        contentId: data.dec(_f$contentId),
        oldTitle: data.dec(_f$oldTitle),
        newTitle: data.dec(_f$newTitle),
        oldBody: data.dec(_f$oldBody),
        newBody: data.dec(_f$newBody));
  }

  @override
  final Function instantiate = _instantiate;

  static ReviewEditLog fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ReviewEditLog>(map);
  }

  static ReviewEditLog fromJson(String json) {
    return ensureInitialized().decodeJson<ReviewEditLog>(json);
  }
}

mixin ReviewEditLogMappable {
  String toJson() {
    return ReviewEditLogMapper.ensureInitialized()
        .encodeJson<ReviewEditLog>(this as ReviewEditLog);
  }

  Map<String, dynamic> toMap() {
    return ReviewEditLogMapper.ensureInitialized()
        .encodeMap<ReviewEditLog>(this as ReviewEditLog);
  }

  ReviewEditLogCopyWith<ReviewEditLog, ReviewEditLog, ReviewEditLog>
      get copyWith => _ReviewEditLogCopyWithImpl<ReviewEditLog, ReviewEditLog>(
          this as ReviewEditLog, $identity, $identity);
  @override
  String toString() {
    return ReviewEditLogMapper.ensureInitialized()
        .stringifyValue(this as ReviewEditLog);
  }

  @override
  bool operator ==(Object other) {
    return ReviewEditLogMapper.ensureInitialized()
        .equalsValue(this as ReviewEditLog, other);
  }

  @override
  int get hashCode {
    return ReviewEditLogMapper.ensureInitialized()
        .hashValue(this as ReviewEditLog);
  }
}

extension ReviewEditLogValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ReviewEditLog, $Out> {
  ReviewEditLogCopyWith<$R, ReviewEditLog, $Out> get $asReviewEditLog =>
      $base.as((v, t, t2) => _ReviewEditLogCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ReviewEditLogCopyWith<$R, $In extends ReviewEditLog, $Out>
    implements CommentEditLogCopyWith<$R, $In, $Out> {
  @override
  $R call(
      {String? id,
      String? contentId,
      String? oldTitle,
      String? newTitle,
      String? oldBody,
      String? newBody});
  ReviewEditLogCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ReviewEditLogCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ReviewEditLog, $Out>
    implements ReviewEditLogCopyWith<$R, ReviewEditLog, $Out> {
  _ReviewEditLogCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ReviewEditLog> $mapper =
      ReviewEditLogMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? contentId,
          String? oldTitle,
          String? newTitle,
          String? oldBody,
          String? newBody}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (contentId != null) #contentId: contentId,
        if (oldTitle != null) #oldTitle: oldTitle,
        if (newTitle != null) #newTitle: newTitle,
        if (oldBody != null) #oldBody: oldBody,
        if (newBody != null) #newBody: newBody
      }));
  @override
  ReviewEditLog $make(CopyWithData data) => ReviewEditLog(
      id: data.get(#id, or: $value.id),
      contentId: data.get(#contentId, or: $value.contentId),
      oldTitle: data.get(#oldTitle, or: $value.oldTitle),
      newTitle: data.get(#newTitle, or: $value.newTitle),
      oldBody: data.get(#oldBody, or: $value.oldBody),
      newBody: data.get(#newBody, or: $value.newBody));

  @override
  ReviewEditLogCopyWith<$R2, ReviewEditLog, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ReviewEditLogCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
