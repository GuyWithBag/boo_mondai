// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'deck_comment.dto.dart';

class DeckCommentMapper extends ClassMapperBase<DeckComment> {
  DeckCommentMapper._();

  static DeckCommentMapper? _instance;
  static DeckCommentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DeckCommentMapper._());
      CachedProfileMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DeckComment';

  static String _$id(DeckComment v) => v.id;
  static const Field<DeckComment, String> _f$id = Field('id', _$id);
  static String _$deckId(DeckComment v) => v.deckId;
  static const Field<DeckComment, String> _f$deckId =
      Field('deckId', _$deckId, key: r'deck_id');
  static String _$userId(DeckComment v) => v.userId;
  static const Field<DeckComment, String> _f$userId =
      Field('userId', _$userId, key: r'user_id');
  static String? _$parentCommentId(DeckComment v) => v.parentCommentId;
  static const Field<DeckComment, String> _f$parentCommentId = Field(
      'parentCommentId', _$parentCommentId,
      key: r'parent_comment_id', opt: true);
  static String _$body(DeckComment v) => v.body;
  static const Field<DeckComment, String> _f$body = Field('body', _$body);
  static bool _$isDeleted(DeckComment v) => v.isDeleted;
  static const Field<DeckComment, bool> _f$isDeleted = Field(
      'isDeleted', _$isDeleted,
      key: r'is_deleted', opt: true, def: false);
  static DateTime _$createdAt(DeckComment v) => v.createdAt;
  static const Field<DeckComment, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static DateTime _$updatedAt(DeckComment v) => v.updatedAt;
  static const Field<DeckComment, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, key: r'updated_at');
  static CachedProfile? _$userProfile(DeckComment v) => v.userProfile;
  static const Field<DeckComment, CachedProfile> _f$userProfile =
      Field('userProfile', _$userProfile, key: r'user_profile', opt: true);

  @override
  final MappableFields<DeckComment> fields = const {
    #id: _f$id,
    #deckId: _f$deckId,
    #userId: _f$userId,
    #parentCommentId: _f$parentCommentId,
    #body: _f$body,
    #isDeleted: _f$isDeleted,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #userProfile: _f$userProfile,
  };

  static DeckComment _instantiate(DecodingData data) {
    return DeckComment(
        id: data.dec(_f$id),
        deckId: data.dec(_f$deckId),
        userId: data.dec(_f$userId),
        parentCommentId: data.dec(_f$parentCommentId),
        body: data.dec(_f$body),
        isDeleted: data.dec(_f$isDeleted),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt),
        userProfile: data.dec(_f$userProfile));
  }

  @override
  final Function instantiate = _instantiate;

  static DeckComment fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DeckComment>(map);
  }

  static DeckComment fromJson(String json) {
    return ensureInitialized().decodeJson<DeckComment>(json);
  }
}

mixin DeckCommentMappable {
  String toJson() {
    return DeckCommentMapper.ensureInitialized()
        .encodeJson<DeckComment>(this as DeckComment);
  }

  Map<String, dynamic> toMap() {
    return DeckCommentMapper.ensureInitialized()
        .encodeMap<DeckComment>(this as DeckComment);
  }

  DeckCommentCopyWith<DeckComment, DeckComment, DeckComment> get copyWith =>
      _DeckCommentCopyWithImpl<DeckComment, DeckComment>(
          this as DeckComment, $identity, $identity);
  @override
  String toString() {
    return DeckCommentMapper.ensureInitialized()
        .stringifyValue(this as DeckComment);
  }

  @override
  bool operator ==(Object other) {
    return DeckCommentMapper.ensureInitialized()
        .equalsValue(this as DeckComment, other);
  }

  @override
  int get hashCode {
    return DeckCommentMapper.ensureInitialized().hashValue(this as DeckComment);
  }
}

extension DeckCommentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DeckComment, $Out> {
  DeckCommentCopyWith<$R, DeckComment, $Out> get $asDeckComment =>
      $base.as((v, t, t2) => _DeckCommentCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DeckCommentCopyWith<$R, $In extends DeckComment, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  CachedProfileCopyWith<$R, CachedProfile, CachedProfile>? get userProfile;
  $R call(
      {String? id,
      String? deckId,
      String? userId,
      String? parentCommentId,
      String? body,
      bool? isDeleted,
      DateTime? createdAt,
      DateTime? updatedAt,
      CachedProfile? userProfile});
  DeckCommentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DeckCommentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DeckComment, $Out>
    implements DeckCommentCopyWith<$R, DeckComment, $Out> {
  _DeckCommentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DeckComment> $mapper =
      DeckCommentMapper.ensureInitialized();
  @override
  CachedProfileCopyWith<$R, CachedProfile, CachedProfile>? get userProfile =>
      $value.userProfile?.copyWith.$chain((v) => call(userProfile: v));
  @override
  $R call(
          {String? id,
          String? deckId,
          String? userId,
          Object? parentCommentId = $none,
          String? body,
          bool? isDeleted,
          DateTime? createdAt,
          DateTime? updatedAt,
          Object? userProfile = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (deckId != null) #deckId: deckId,
        if (userId != null) #userId: userId,
        if (parentCommentId != $none) #parentCommentId: parentCommentId,
        if (body != null) #body: body,
        if (isDeleted != null) #isDeleted: isDeleted,
        if (createdAt != null) #createdAt: createdAt,
        if (updatedAt != null) #updatedAt: updatedAt,
        if (userProfile != $none) #userProfile: userProfile
      }));
  @override
  DeckComment $make(CopyWithData data) => DeckComment(
      id: data.get(#id, or: $value.id),
      deckId: data.get(#deckId, or: $value.deckId),
      userId: data.get(#userId, or: $value.userId),
      parentCommentId: data.get(#parentCommentId, or: $value.parentCommentId),
      body: data.get(#body, or: $value.body),
      isDeleted: data.get(#isDeleted, or: $value.isDeleted),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt),
      userProfile: data.get(#userProfile, or: $value.userProfile));

  @override
  DeckCommentCopyWith<$R2, DeckComment, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _DeckCommentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
