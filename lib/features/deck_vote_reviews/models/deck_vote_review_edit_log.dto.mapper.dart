// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'deck_vote_review_edit_log.dto.dart';

class DeckVoteReviewEditLogMapper
    extends ClassMapperBase<DeckVoteReviewEditLog> {
  DeckVoteReviewEditLogMapper._();

  static DeckVoteReviewEditLogMapper? _instance;
  static DeckVoteReviewEditLogMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DeckVoteReviewEditLogMapper._());
      CachedProfileMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DeckVoteReviewEditLog';

  static String _$id(DeckVoteReviewEditLog v) => v.id;
  static const Field<DeckVoteReviewEditLog, String> _f$id = Field('id', _$id);
  static String _$reviewId(DeckVoteReviewEditLog v) => v.reviewId;
  static const Field<DeckVoteReviewEditLog, String> _f$reviewId = Field(
    'reviewId',
    _$reviewId,
    key: r'review_id',
  );
  static String _$editedBy(DeckVoteReviewEditLog v) => v.editedBy;
  static const Field<DeckVoteReviewEditLog, String> _f$editedBy = Field(
    'editedBy',
    _$editedBy,
    key: r'edited_by',
  );
  static int _$oldVoteValueAtCreation(DeckVoteReviewEditLog v) =>
      v.oldVoteValueAtCreation;
  static const Field<DeckVoteReviewEditLog, int> _f$oldVoteValueAtCreation =
      Field(
        'oldVoteValueAtCreation',
        _$oldVoteValueAtCreation,
        key: r'old_vote_value_at_creation',
      );
  static int _$newVoteValueAtCreation(DeckVoteReviewEditLog v) =>
      v.newVoteValueAtCreation;
  static const Field<DeckVoteReviewEditLog, int> _f$newVoteValueAtCreation =
      Field(
        'newVoteValueAtCreation',
        _$newVoteValueAtCreation,
        key: r'new_vote_value_at_creation',
      );
  static String _$oldTitle(DeckVoteReviewEditLog v) => v.oldTitle;
  static const Field<DeckVoteReviewEditLog, String> _f$oldTitle = Field(
    'oldTitle',
    _$oldTitle,
    key: r'old_title',
  );
  static String _$newTitle(DeckVoteReviewEditLog v) => v.newTitle;
  static const Field<DeckVoteReviewEditLog, String> _f$newTitle = Field(
    'newTitle',
    _$newTitle,
    key: r'new_title',
  );
  static String _$oldBody(DeckVoteReviewEditLog v) => v.oldBody;
  static const Field<DeckVoteReviewEditLog, String> _f$oldBody = Field(
    'oldBody',
    _$oldBody,
    key: r'old_body',
  );
  static String _$newBody(DeckVoteReviewEditLog v) => v.newBody;
  static const Field<DeckVoteReviewEditLog, String> _f$newBody = Field(
    'newBody',
    _$newBody,
    key: r'new_body',
  );
  static DateTime _$editedAt(DeckVoteReviewEditLog v) => v.editedAt;
  static const Field<DeckVoteReviewEditLog, DateTime> _f$editedAt = Field(
    'editedAt',
    _$editedAt,
    key: r'edited_at',
  );
  static CachedProfile? _$editorProfile(DeckVoteReviewEditLog v) =>
      v.editorProfile;
  static const Field<DeckVoteReviewEditLog, CachedProfile> _f$editorProfile =
      Field(
        'editorProfile',
        _$editorProfile,
        key: r'editor_profile',
        opt: true,
      );

  @override
  final MappableFields<DeckVoteReviewEditLog> fields = const {
    #id: _f$id,
    #reviewId: _f$reviewId,
    #editedBy: _f$editedBy,
    #oldVoteValueAtCreation: _f$oldVoteValueAtCreation,
    #newVoteValueAtCreation: _f$newVoteValueAtCreation,
    #oldTitle: _f$oldTitle,
    #newTitle: _f$newTitle,
    #oldBody: _f$oldBody,
    #newBody: _f$newBody,
    #editedAt: _f$editedAt,
    #editorProfile: _f$editorProfile,
  };

  static DeckVoteReviewEditLog _instantiate(DecodingData data) {
    return DeckVoteReviewEditLog(
      id: data.dec(_f$id),
      reviewId: data.dec(_f$reviewId),
      editedBy: data.dec(_f$editedBy),
      oldVoteValueAtCreation: data.dec(_f$oldVoteValueAtCreation),
      newVoteValueAtCreation: data.dec(_f$newVoteValueAtCreation),
      oldTitle: data.dec(_f$oldTitle),
      newTitle: data.dec(_f$newTitle),
      oldBody: data.dec(_f$oldBody),
      newBody: data.dec(_f$newBody),
      editedAt: data.dec(_f$editedAt),
      editorProfile: data.dec(_f$editorProfile),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static DeckVoteReviewEditLog fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DeckVoteReviewEditLog>(map);
  }

  static DeckVoteReviewEditLog fromJson(String json) {
    return ensureInitialized().decodeJson<DeckVoteReviewEditLog>(json);
  }
}

mixin DeckVoteReviewEditLogMappable {
  String toJson() {
    return DeckVoteReviewEditLogMapper.ensureInitialized()
        .encodeJson<DeckVoteReviewEditLog>(this as DeckVoteReviewEditLog);
  }

  Map<String, dynamic> toMap() {
    return DeckVoteReviewEditLogMapper.ensureInitialized()
        .encodeMap<DeckVoteReviewEditLog>(this as DeckVoteReviewEditLog);
  }

  DeckVoteReviewEditLogCopyWith<
    DeckVoteReviewEditLog,
    DeckVoteReviewEditLog,
    DeckVoteReviewEditLog
  >
  get copyWith =>
      _DeckVoteReviewEditLogCopyWithImpl<
        DeckVoteReviewEditLog,
        DeckVoteReviewEditLog
      >(this as DeckVoteReviewEditLog, $identity, $identity);
  @override
  String toString() {
    return DeckVoteReviewEditLogMapper.ensureInitialized().stringifyValue(
      this as DeckVoteReviewEditLog,
    );
  }

  @override
  bool operator ==(Object other) {
    return DeckVoteReviewEditLogMapper.ensureInitialized().equalsValue(
      this as DeckVoteReviewEditLog,
      other,
    );
  }

  @override
  int get hashCode {
    return DeckVoteReviewEditLogMapper.ensureInitialized().hashValue(
      this as DeckVoteReviewEditLog,
    );
  }
}

extension DeckVoteReviewEditLogValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DeckVoteReviewEditLog, $Out> {
  DeckVoteReviewEditLogCopyWith<$R, DeckVoteReviewEditLog, $Out>
  get $asDeckVoteReviewEditLog => $base.as(
    (v, t, t2) => _DeckVoteReviewEditLogCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class DeckVoteReviewEditLogCopyWith<
  $R,
  $In extends DeckVoteReviewEditLog,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  CachedProfileCopyWith<$R, CachedProfile, CachedProfile>? get editorProfile;
  $R call({
    String? id,
    String? reviewId,
    String? editedBy,
    int? oldVoteValueAtCreation,
    int? newVoteValueAtCreation,
    String? oldTitle,
    String? newTitle,
    String? oldBody,
    String? newBody,
    DateTime? editedAt,
    CachedProfile? editorProfile,
  });
  DeckVoteReviewEditLogCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _DeckVoteReviewEditLogCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DeckVoteReviewEditLog, $Out>
    implements DeckVoteReviewEditLogCopyWith<$R, DeckVoteReviewEditLog, $Out> {
  _DeckVoteReviewEditLogCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DeckVoteReviewEditLog> $mapper =
      DeckVoteReviewEditLogMapper.ensureInitialized();
  @override
  CachedProfileCopyWith<$R, CachedProfile, CachedProfile>? get editorProfile =>
      $value.editorProfile?.copyWith.$chain((v) => call(editorProfile: v));
  @override
  $R call({
    String? id,
    String? reviewId,
    String? editedBy,
    int? oldVoteValueAtCreation,
    int? newVoteValueAtCreation,
    String? oldTitle,
    String? newTitle,
    String? oldBody,
    String? newBody,
    DateTime? editedAt,
    Object? editorProfile = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (reviewId != null) #reviewId: reviewId,
      if (editedBy != null) #editedBy: editedBy,
      if (oldVoteValueAtCreation != null)
        #oldVoteValueAtCreation: oldVoteValueAtCreation,
      if (newVoteValueAtCreation != null)
        #newVoteValueAtCreation: newVoteValueAtCreation,
      if (oldTitle != null) #oldTitle: oldTitle,
      if (newTitle != null) #newTitle: newTitle,
      if (oldBody != null) #oldBody: oldBody,
      if (newBody != null) #newBody: newBody,
      if (editedAt != null) #editedAt: editedAt,
      if (editorProfile != $none) #editorProfile: editorProfile,
    }),
  );
  @override
  DeckVoteReviewEditLog $make(CopyWithData data) => DeckVoteReviewEditLog(
    id: data.get(#id, or: $value.id),
    reviewId: data.get(#reviewId, or: $value.reviewId),
    editedBy: data.get(#editedBy, or: $value.editedBy),
    oldVoteValueAtCreation: data.get(
      #oldVoteValueAtCreation,
      or: $value.oldVoteValueAtCreation,
    ),
    newVoteValueAtCreation: data.get(
      #newVoteValueAtCreation,
      or: $value.newVoteValueAtCreation,
    ),
    oldTitle: data.get(#oldTitle, or: $value.oldTitle),
    newTitle: data.get(#newTitle, or: $value.newTitle),
    oldBody: data.get(#oldBody, or: $value.oldBody),
    newBody: data.get(#newBody, or: $value.newBody),
    editedAt: data.get(#editedAt, or: $value.editedAt),
    editorProfile: data.get(#editorProfile, or: $value.editorProfile),
  );

  @override
  DeckVoteReviewEditLogCopyWith<$R2, DeckVoteReviewEditLog, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _DeckVoteReviewEditLogCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
