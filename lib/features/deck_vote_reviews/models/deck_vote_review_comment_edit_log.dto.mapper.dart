// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'deck_vote_review_comment_edit_log.dto.dart';

class DeckVoteReviewCommentEditLogMapper
    extends ClassMapperBase<DeckVoteReviewCommentEditLog> {
  DeckVoteReviewCommentEditLogMapper._();

  static DeckVoteReviewCommentEditLogMapper? _instance;
  static DeckVoteReviewCommentEditLogMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = DeckVoteReviewCommentEditLogMapper._());
      CachedProfileMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DeckVoteReviewCommentEditLog';

  static String _$id(DeckVoteReviewCommentEditLog v) => v.id;
  static const Field<DeckVoteReviewCommentEditLog, String> _f$id =
      Field('id', _$id);
  static String _$commentId(DeckVoteReviewCommentEditLog v) => v.commentId;
  static const Field<DeckVoteReviewCommentEditLog, String> _f$commentId =
      Field('commentId', _$commentId, key: r'comment_id');
  static String _$editedBy(DeckVoteReviewCommentEditLog v) => v.editedBy;
  static const Field<DeckVoteReviewCommentEditLog, String> _f$editedBy =
      Field('editedBy', _$editedBy, key: r'edited_by');
  static String _$oldBody(DeckVoteReviewCommentEditLog v) => v.oldBody;
  static const Field<DeckVoteReviewCommentEditLog, String> _f$oldBody =
      Field('oldBody', _$oldBody, key: r'old_body');
  static String _$newBody(DeckVoteReviewCommentEditLog v) => v.newBody;
  static const Field<DeckVoteReviewCommentEditLog, String> _f$newBody =
      Field('newBody', _$newBody, key: r'new_body');
  static DateTime _$editedAt(DeckVoteReviewCommentEditLog v) => v.editedAt;
  static const Field<DeckVoteReviewCommentEditLog, DateTime> _f$editedAt =
      Field('editedAt', _$editedAt, key: r'edited_at');
  static CachedProfile? _$editorProfile(DeckVoteReviewCommentEditLog v) =>
      v.editorProfile;
  static const Field<DeckVoteReviewCommentEditLog, CachedProfile>
      _f$editorProfile = Field('editorProfile', _$editorProfile,
          key: r'editor_profile', opt: true);

  @override
  final MappableFields<DeckVoteReviewCommentEditLog> fields = const {
    #id: _f$id,
    #commentId: _f$commentId,
    #editedBy: _f$editedBy,
    #oldBody: _f$oldBody,
    #newBody: _f$newBody,
    #editedAt: _f$editedAt,
    #editorProfile: _f$editorProfile,
  };

  static DeckVoteReviewCommentEditLog _instantiate(DecodingData data) {
    return DeckVoteReviewCommentEditLog(
        id: data.dec(_f$id),
        commentId: data.dec(_f$commentId),
        editedBy: data.dec(_f$editedBy),
        oldBody: data.dec(_f$oldBody),
        newBody: data.dec(_f$newBody),
        editedAt: data.dec(_f$editedAt),
        editorProfile: data.dec(_f$editorProfile));
  }

  @override
  final Function instantiate = _instantiate;

  static DeckVoteReviewCommentEditLog fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DeckVoteReviewCommentEditLog>(map);
  }

  static DeckVoteReviewCommentEditLog fromJson(String json) {
    return ensureInitialized().decodeJson<DeckVoteReviewCommentEditLog>(json);
  }
}

mixin DeckVoteReviewCommentEditLogMappable {
  String toJson() {
    return DeckVoteReviewCommentEditLogMapper.ensureInitialized()
        .encodeJson<DeckVoteReviewCommentEditLog>(
            this as DeckVoteReviewCommentEditLog);
  }

  Map<String, dynamic> toMap() {
    return DeckVoteReviewCommentEditLogMapper.ensureInitialized()
        .encodeMap<DeckVoteReviewCommentEditLog>(
            this as DeckVoteReviewCommentEditLog);
  }

  DeckVoteReviewCommentEditLogCopyWith<DeckVoteReviewCommentEditLog,
          DeckVoteReviewCommentEditLog, DeckVoteReviewCommentEditLog>
      get copyWith => _DeckVoteReviewCommentEditLogCopyWithImpl<
              DeckVoteReviewCommentEditLog, DeckVoteReviewCommentEditLog>(
          this as DeckVoteReviewCommentEditLog, $identity, $identity);
  @override
  String toString() {
    return DeckVoteReviewCommentEditLogMapper.ensureInitialized()
        .stringifyValue(this as DeckVoteReviewCommentEditLog);
  }

  @override
  bool operator ==(Object other) {
    return DeckVoteReviewCommentEditLogMapper.ensureInitialized()
        .equalsValue(this as DeckVoteReviewCommentEditLog, other);
  }

  @override
  int get hashCode {
    return DeckVoteReviewCommentEditLogMapper.ensureInitialized()
        .hashValue(this as DeckVoteReviewCommentEditLog);
  }
}

extension DeckVoteReviewCommentEditLogValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DeckVoteReviewCommentEditLog, $Out> {
  DeckVoteReviewCommentEditLogCopyWith<$R, DeckVoteReviewCommentEditLog, $Out>
      get $asDeckVoteReviewCommentEditLog => $base.as((v, t, t2) =>
          _DeckVoteReviewCommentEditLogCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DeckVoteReviewCommentEditLogCopyWith<
    $R,
    $In extends DeckVoteReviewCommentEditLog,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  CachedProfileCopyWith<$R, CachedProfile, CachedProfile>? get editorProfile;
  $R call(
      {String? id,
      String? commentId,
      String? editedBy,
      String? oldBody,
      String? newBody,
      DateTime? editedAt,
      CachedProfile? editorProfile});
  DeckVoteReviewCommentEditLogCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _DeckVoteReviewCommentEditLogCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DeckVoteReviewCommentEditLog, $Out>
    implements
        DeckVoteReviewCommentEditLogCopyWith<$R, DeckVoteReviewCommentEditLog,
            $Out> {
  _DeckVoteReviewCommentEditLogCopyWithImpl(
      super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DeckVoteReviewCommentEditLog> $mapper =
      DeckVoteReviewCommentEditLogMapper.ensureInitialized();
  @override
  CachedProfileCopyWith<$R, CachedProfile, CachedProfile>? get editorProfile =>
      $value.editorProfile?.copyWith.$chain((v) => call(editorProfile: v));
  @override
  $R call(
          {String? id,
          String? commentId,
          String? editedBy,
          String? oldBody,
          String? newBody,
          DateTime? editedAt,
          Object? editorProfile = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (commentId != null) #commentId: commentId,
        if (editedBy != null) #editedBy: editedBy,
        if (oldBody != null) #oldBody: oldBody,
        if (newBody != null) #newBody: newBody,
        if (editedAt != null) #editedAt: editedAt,
        if (editorProfile != $none) #editorProfile: editorProfile
      }));
  @override
  DeckVoteReviewCommentEditLog $make(CopyWithData data) =>
      DeckVoteReviewCommentEditLog(
          id: data.get(#id, or: $value.id),
          commentId: data.get(#commentId, or: $value.commentId),
          editedBy: data.get(#editedBy, or: $value.editedBy),
          oldBody: data.get(#oldBody, or: $value.oldBody),
          newBody: data.get(#newBody, or: $value.newBody),
          editedAt: data.get(#editedAt, or: $value.editedAt),
          editorProfile: data.get(#editorProfile, or: $value.editorProfile));

  @override
  DeckVoteReviewCommentEditLogCopyWith<$R2, DeckVoteReviewCommentEditLog, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _DeckVoteReviewCommentEditLogCopyWithImpl<$R2, $Out2>(
              $value, $cast, t);
}
