// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'deck_vote_review_comment.dto.dart';

class DeckVoteReviewCommentMapper
    extends ClassMapperBase<DeckVoteReviewComment> {
  DeckVoteReviewCommentMapper._();

  static DeckVoteReviewCommentMapper? _instance;
  static DeckVoteReviewCommentMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DeckVoteReviewCommentMapper._());
      CachedProfileMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DeckVoteReviewComment';

  static String _$id(DeckVoteReviewComment v) => v.id;
  static const Field<DeckVoteReviewComment, String> _f$id = Field('id', _$id);
  static String _$reviewId(DeckVoteReviewComment v) => v.reviewId;
  static const Field<DeckVoteReviewComment, String> _f$reviewId =
      Field('reviewId', _$reviewId, key: r'review_id');
  static String _$userId(DeckVoteReviewComment v) => v.userId;
  static const Field<DeckVoteReviewComment, String> _f$userId =
      Field('userId', _$userId, key: r'user_id');
  static String? _$parentCommentId(DeckVoteReviewComment v) =>
      v.parentCommentId;
  static const Field<DeckVoteReviewComment, String> _f$parentCommentId = Field(
      'parentCommentId', _$parentCommentId,
      key: r'parent_comment_id', opt: true);
  static String _$body(DeckVoteReviewComment v) => v.body;
  static const Field<DeckVoteReviewComment, String> _f$body =
      Field('body', _$body);
  static bool _$isDeleted(DeckVoteReviewComment v) => v.isDeleted;
  static const Field<DeckVoteReviewComment, bool> _f$isDeleted = Field(
      'isDeleted', _$isDeleted,
      key: r'is_deleted', opt: true, def: false);
  static DateTime _$createdAt(DeckVoteReviewComment v) => v.createdAt;
  static const Field<DeckVoteReviewComment, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static DateTime _$updatedAt(DeckVoteReviewComment v) => v.updatedAt;
  static const Field<DeckVoteReviewComment, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, key: r'updated_at');
  static CachedProfile? _$userProfile(DeckVoteReviewComment v) => v.userProfile;
  static const Field<DeckVoteReviewComment, CachedProfile> _f$userProfile =
      Field('userProfile', _$userProfile, key: r'user_profile', opt: true);

  @override
  final MappableFields<DeckVoteReviewComment> fields = const {
    #id: _f$id,
    #reviewId: _f$reviewId,
    #userId: _f$userId,
    #parentCommentId: _f$parentCommentId,
    #body: _f$body,
    #isDeleted: _f$isDeleted,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #userProfile: _f$userProfile,
  };

  static DeckVoteReviewComment _instantiate(DecodingData data) {
    return DeckVoteReviewComment(
        id: data.dec(_f$id),
        reviewId: data.dec(_f$reviewId),
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

  static DeckVoteReviewComment fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DeckVoteReviewComment>(map);
  }

  static DeckVoteReviewComment fromJson(String json) {
    return ensureInitialized().decodeJson<DeckVoteReviewComment>(json);
  }
}

mixin DeckVoteReviewCommentMappable {
  String toJson() {
    return DeckVoteReviewCommentMapper.ensureInitialized()
        .encodeJson<DeckVoteReviewComment>(this as DeckVoteReviewComment);
  }

  Map<String, dynamic> toMap() {
    return DeckVoteReviewCommentMapper.ensureInitialized()
        .encodeMap<DeckVoteReviewComment>(this as DeckVoteReviewComment);
  }

  DeckVoteReviewCommentCopyWith<DeckVoteReviewComment, DeckVoteReviewComment,
      DeckVoteReviewComment> get copyWith => _DeckVoteReviewCommentCopyWithImpl<
          DeckVoteReviewComment, DeckVoteReviewComment>(
      this as DeckVoteReviewComment, $identity, $identity);
  @override
  String toString() {
    return DeckVoteReviewCommentMapper.ensureInitialized()
        .stringifyValue(this as DeckVoteReviewComment);
  }

  @override
  bool operator ==(Object other) {
    return DeckVoteReviewCommentMapper.ensureInitialized()
        .equalsValue(this as DeckVoteReviewComment, other);
  }

  @override
  int get hashCode {
    return DeckVoteReviewCommentMapper.ensureInitialized()
        .hashValue(this as DeckVoteReviewComment);
  }
}

extension DeckVoteReviewCommentValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DeckVoteReviewComment, $Out> {
  DeckVoteReviewCommentCopyWith<$R, DeckVoteReviewComment, $Out>
      get $asDeckVoteReviewComment => $base.as(
          (v, t, t2) => _DeckVoteReviewCommentCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DeckVoteReviewCommentCopyWith<
    $R,
    $In extends DeckVoteReviewComment,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  CachedProfileCopyWith<$R, CachedProfile, CachedProfile>? get userProfile;
  $R call(
      {String? id,
      String? reviewId,
      String? userId,
      String? parentCommentId,
      String? body,
      bool? isDeleted,
      DateTime? createdAt,
      DateTime? updatedAt,
      CachedProfile? userProfile});
  DeckVoteReviewCommentCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _DeckVoteReviewCommentCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DeckVoteReviewComment, $Out>
    implements DeckVoteReviewCommentCopyWith<$R, DeckVoteReviewComment, $Out> {
  _DeckVoteReviewCommentCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DeckVoteReviewComment> $mapper =
      DeckVoteReviewCommentMapper.ensureInitialized();
  @override
  CachedProfileCopyWith<$R, CachedProfile, CachedProfile>? get userProfile =>
      $value.userProfile?.copyWith.$chain((v) => call(userProfile: v));
  @override
  $R call(
          {String? id,
          String? reviewId,
          String? userId,
          Object? parentCommentId = $none,
          String? body,
          bool? isDeleted,
          DateTime? createdAt,
          DateTime? updatedAt,
          Object? userProfile = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (reviewId != null) #reviewId: reviewId,
        if (userId != null) #userId: userId,
        if (parentCommentId != $none) #parentCommentId: parentCommentId,
        if (body != null) #body: body,
        if (isDeleted != null) #isDeleted: isDeleted,
        if (createdAt != null) #createdAt: createdAt,
        if (updatedAt != null) #updatedAt: updatedAt,
        if (userProfile != $none) #userProfile: userProfile
      }));
  @override
  DeckVoteReviewComment $make(CopyWithData data) => DeckVoteReviewComment(
      id: data.get(#id, or: $value.id),
      reviewId: data.get(#reviewId, or: $value.reviewId),
      userId: data.get(#userId, or: $value.userId),
      parentCommentId: data.get(#parentCommentId, or: $value.parentCommentId),
      body: data.get(#body, or: $value.body),
      isDeleted: data.get(#isDeleted, or: $value.isDeleted),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt),
      userProfile: data.get(#userProfile, or: $value.userProfile));

  @override
  DeckVoteReviewCommentCopyWith<$R2, DeckVoteReviewComment, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _DeckVoteReviewCommentCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
