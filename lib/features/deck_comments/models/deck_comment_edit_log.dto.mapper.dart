// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'deck_comment_edit_log.dto.dart';

class DeckCommentEditLogMapper extends ClassMapperBase<DeckCommentEditLog> {
  DeckCommentEditLogMapper._();

  static DeckCommentEditLogMapper? _instance;
  static DeckCommentEditLogMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DeckCommentEditLogMapper._());
      CachedProfileMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DeckCommentEditLog';

  static String _$id(DeckCommentEditLog v) => v.id;
  static const Field<DeckCommentEditLog, String> _f$id = Field('id', _$id);
  static String _$commentId(DeckCommentEditLog v) => v.commentId;
  static const Field<DeckCommentEditLog, String> _f$commentId = Field(
    'commentId',
    _$commentId,
    key: r'comment_id',
  );
  static String _$editedBy(DeckCommentEditLog v) => v.editedBy;
  static const Field<DeckCommentEditLog, String> _f$editedBy = Field(
    'editedBy',
    _$editedBy,
    key: r'edited_by',
  );
  static String _$oldBody(DeckCommentEditLog v) => v.oldBody;
  static const Field<DeckCommentEditLog, String> _f$oldBody = Field(
    'oldBody',
    _$oldBody,
    key: r'old_body',
  );
  static String _$newBody(DeckCommentEditLog v) => v.newBody;
  static const Field<DeckCommentEditLog, String> _f$newBody = Field(
    'newBody',
    _$newBody,
    key: r'new_body',
  );
  static DateTime _$editedAt(DeckCommentEditLog v) => v.editedAt;
  static const Field<DeckCommentEditLog, DateTime> _f$editedAt = Field(
    'editedAt',
    _$editedAt,
    key: r'edited_at',
  );
  static CachedProfile? _$editorProfile(DeckCommentEditLog v) =>
      v.editorProfile;
  static const Field<DeckCommentEditLog, CachedProfile> _f$editorProfile =
      Field(
        'editorProfile',
        _$editorProfile,
        key: r'editor_profile',
        opt: true,
      );

  @override
  final MappableFields<DeckCommentEditLog> fields = const {
    #id: _f$id,
    #commentId: _f$commentId,
    #editedBy: _f$editedBy,
    #oldBody: _f$oldBody,
    #newBody: _f$newBody,
    #editedAt: _f$editedAt,
    #editorProfile: _f$editorProfile,
  };

  static DeckCommentEditLog _instantiate(DecodingData data) {
    return DeckCommentEditLog(
      id: data.dec(_f$id),
      commentId: data.dec(_f$commentId),
      editedBy: data.dec(_f$editedBy),
      oldBody: data.dec(_f$oldBody),
      newBody: data.dec(_f$newBody),
      editedAt: data.dec(_f$editedAt),
      editorProfile: data.dec(_f$editorProfile),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DeckCommentEditLog fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DeckCommentEditLog>(map);
  }

  static DeckCommentEditLog fromJson(String json) {
    return ensureInitialized().decodeJson<DeckCommentEditLog>(json);
  }
}

mixin DeckCommentEditLogMappable {
  String toJson() {
    return DeckCommentEditLogMapper.ensureInitialized()
        .encodeJson<DeckCommentEditLog>(this as DeckCommentEditLog);
  }

  Map<String, dynamic> toMap() {
    return DeckCommentEditLogMapper.ensureInitialized()
        .encodeMap<DeckCommentEditLog>(this as DeckCommentEditLog);
  }

  DeckCommentEditLogCopyWith<
    DeckCommentEditLog,
    DeckCommentEditLog,
    DeckCommentEditLog
  >
  get copyWith =>
      _DeckCommentEditLogCopyWithImpl<DeckCommentEditLog, DeckCommentEditLog>(
        this as DeckCommentEditLog,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return DeckCommentEditLogMapper.ensureInitialized().stringifyValue(
      this as DeckCommentEditLog,
    );
  }

  @override
  bool operator ==(Object other) {
    return DeckCommentEditLogMapper.ensureInitialized().equalsValue(
      this as DeckCommentEditLog,
      other,
    );
  }

  @override
  int get hashCode {
    return DeckCommentEditLogMapper.ensureInitialized().hashValue(
      this as DeckCommentEditLog,
    );
  }
}

extension DeckCommentEditLogValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DeckCommentEditLog, $Out> {
  DeckCommentEditLogCopyWith<$R, DeckCommentEditLog, $Out>
  get $asDeckCommentEditLog => $base.as(
    (v, t, t2) => _DeckCommentEditLogCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class DeckCommentEditLogCopyWith<
  $R,
  $In extends DeckCommentEditLog,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  CachedProfileCopyWith<$R, CachedProfile, CachedProfile>? get editorProfile;
  $R call({
    String? id,
    String? commentId,
    String? editedBy,
    String? oldBody,
    String? newBody,
    DateTime? editedAt,
    CachedProfile? editorProfile,
  });
  DeckCommentEditLogCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DeckCommentEditLogCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DeckCommentEditLog, $Out>
    implements DeckCommentEditLogCopyWith<$R, DeckCommentEditLog, $Out> {
  _DeckCommentEditLogCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DeckCommentEditLog> $mapper =
      DeckCommentEditLogMapper.ensureInitialized();
  @override
  CachedProfileCopyWith<$R, CachedProfile, CachedProfile>? get editorProfile =>
      $value.editorProfile?.copyWith.$chain((v) => call(editorProfile: v));
  @override
  $R call({
    String? id,
    String? commentId,
    String? editedBy,
    String? oldBody,
    String? newBody,
    DateTime? editedAt,
    Object? editorProfile = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (commentId != null) #commentId: commentId,
      if (editedBy != null) #editedBy: editedBy,
      if (oldBody != null) #oldBody: oldBody,
      if (newBody != null) #newBody: newBody,
      if (editedAt != null) #editedAt: editedAt,
      if (editorProfile != $none) #editorProfile: editorProfile,
    }),
  );
  @override
  DeckCommentEditLog $make(CopyWithData data) => DeckCommentEditLog(
    id: data.get(#id, or: $value.id),
    commentId: data.get(#commentId, or: $value.commentId),
    editedBy: data.get(#editedBy, or: $value.editedBy),
    oldBody: data.get(#oldBody, or: $value.oldBody),
    newBody: data.get(#newBody, or: $value.newBody),
    editedAt: data.get(#editedAt, or: $value.editedAt),
    editorProfile: data.get(#editorProfile, or: $value.editorProfile),
  );

  @override
  DeckCommentEditLogCopyWith<$R2, DeckCommentEditLog, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _DeckCommentEditLogCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
