// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'deck_vote_review.dto.dart';

class DeckVoteReviewMapper extends ClassMapperBase<DeckVoteReview> {
  DeckVoteReviewMapper._();

  static DeckVoteReviewMapper? _instance;
  static DeckVoteReviewMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DeckVoteReviewMapper._());
      CachedProfileMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'DeckVoteReview';

  static String _$id(DeckVoteReview v) => v.id;
  static const Field<DeckVoteReview, String> _f$id = Field('id', _$id);
  static String _$deckId(DeckVoteReview v) => v.deckId;
  static const Field<DeckVoteReview, String> _f$deckId =
      Field('deckId', _$deckId, key: r'deck_id');
  static String _$userId(DeckVoteReview v) => v.userId;
  static const Field<DeckVoteReview, String> _f$userId =
      Field('userId', _$userId, key: r'user_id');
  static int _$voteValueAtCreation(DeckVoteReview v) => v.voteValueAtCreation;
  static const Field<DeckVoteReview, int> _f$voteValueAtCreation = Field(
      'voteValueAtCreation', _$voteValueAtCreation,
      key: r'vote_value_at_creation');
  static String _$title(DeckVoteReview v) => v.title;
  static const Field<DeckVoteReview, String> _f$title =
      Field('title', _$title, opt: true, def: '');
  static String _$body(DeckVoteReview v) => v.body;
  static const Field<DeckVoteReview, String> _f$body = Field('body', _$body);
  static bool _$isDeleted(DeckVoteReview v) => v.isDeleted;
  static const Field<DeckVoteReview, bool> _f$isDeleted = Field(
      'isDeleted', _$isDeleted,
      key: r'is_deleted', opt: true, def: false);
  static DateTime _$createdAt(DeckVoteReview v) => v.createdAt;
  static const Field<DeckVoteReview, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static DateTime _$updatedAt(DeckVoteReview v) => v.updatedAt;
  static const Field<DeckVoteReview, DateTime> _f$updatedAt =
      Field('updatedAt', _$updatedAt, key: r'updated_at');
  static CachedProfile? _$userProfile(DeckVoteReview v) => v.userProfile;
  static const Field<DeckVoteReview, CachedProfile> _f$userProfile =
      Field('userProfile', _$userProfile, key: r'user_profile', opt: true);

  @override
  final MappableFields<DeckVoteReview> fields = const {
    #id: _f$id,
    #deckId: _f$deckId,
    #userId: _f$userId,
    #voteValueAtCreation: _f$voteValueAtCreation,
    #title: _f$title,
    #body: _f$body,
    #isDeleted: _f$isDeleted,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #userProfile: _f$userProfile,
  };

  static DeckVoteReview _instantiate(DecodingData data) {
    return DeckVoteReview(
        id: data.dec(_f$id),
        deckId: data.dec(_f$deckId),
        userId: data.dec(_f$userId),
        voteValueAtCreation: data.dec(_f$voteValueAtCreation),
        title: data.dec(_f$title),
        body: data.dec(_f$body),
        isDeleted: data.dec(_f$isDeleted),
        createdAt: data.dec(_f$createdAt),
        updatedAt: data.dec(_f$updatedAt),
        userProfile: data.dec(_f$userProfile));
  }

  @override
  final Function instantiate = _instantiate;

  static DeckVoteReview fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DeckVoteReview>(map);
  }

  static DeckVoteReview fromJson(String json) {
    return ensureInitialized().decodeJson<DeckVoteReview>(json);
  }
}

mixin DeckVoteReviewMappable {
  String toJson() {
    return DeckVoteReviewMapper.ensureInitialized()
        .encodeJson<DeckVoteReview>(this as DeckVoteReview);
  }

  Map<String, dynamic> toMap() {
    return DeckVoteReviewMapper.ensureInitialized()
        .encodeMap<DeckVoteReview>(this as DeckVoteReview);
  }

  DeckVoteReviewCopyWith<DeckVoteReview, DeckVoteReview, DeckVoteReview>
      get copyWith =>
          _DeckVoteReviewCopyWithImpl<DeckVoteReview, DeckVoteReview>(
              this as DeckVoteReview, $identity, $identity);
  @override
  String toString() {
    return DeckVoteReviewMapper.ensureInitialized()
        .stringifyValue(this as DeckVoteReview);
  }

  @override
  bool operator ==(Object other) {
    return DeckVoteReviewMapper.ensureInitialized()
        .equalsValue(this as DeckVoteReview, other);
  }

  @override
  int get hashCode {
    return DeckVoteReviewMapper.ensureInitialized()
        .hashValue(this as DeckVoteReview);
  }
}

extension DeckVoteReviewValueCopy<$R, $Out>
    on ObjectCopyWith<$R, DeckVoteReview, $Out> {
  DeckVoteReviewCopyWith<$R, DeckVoteReview, $Out> get $asDeckVoteReview =>
      $base.as((v, t, t2) => _DeckVoteReviewCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DeckVoteReviewCopyWith<$R, $In extends DeckVoteReview, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  CachedProfileCopyWith<$R, CachedProfile, CachedProfile>? get userProfile;
  $R call(
      {String? id,
      String? deckId,
      String? userId,
      int? voteValueAtCreation,
      String? title,
      String? body,
      bool? isDeleted,
      DateTime? createdAt,
      DateTime? updatedAt,
      CachedProfile? userProfile});
  DeckVoteReviewCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _DeckVoteReviewCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DeckVoteReview, $Out>
    implements DeckVoteReviewCopyWith<$R, DeckVoteReview, $Out> {
  _DeckVoteReviewCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DeckVoteReview> $mapper =
      DeckVoteReviewMapper.ensureInitialized();
  @override
  CachedProfileCopyWith<$R, CachedProfile, CachedProfile>? get userProfile =>
      $value.userProfile?.copyWith.$chain((v) => call(userProfile: v));
  @override
  $R call(
          {String? id,
          String? deckId,
          String? userId,
          int? voteValueAtCreation,
          String? title,
          String? body,
          bool? isDeleted,
          DateTime? createdAt,
          DateTime? updatedAt,
          Object? userProfile = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (deckId != null) #deckId: deckId,
        if (userId != null) #userId: userId,
        if (voteValueAtCreation != null)
          #voteValueAtCreation: voteValueAtCreation,
        if (title != null) #title: title,
        if (body != null) #body: body,
        if (isDeleted != null) #isDeleted: isDeleted,
        if (createdAt != null) #createdAt: createdAt,
        if (updatedAt != null) #updatedAt: updatedAt,
        if (userProfile != $none) #userProfile: userProfile
      }));
  @override
  DeckVoteReview $make(CopyWithData data) => DeckVoteReview(
      id: data.get(#id, or: $value.id),
      deckId: data.get(#deckId, or: $value.deckId),
      userId: data.get(#userId, or: $value.userId),
      voteValueAtCreation:
          data.get(#voteValueAtCreation, or: $value.voteValueAtCreation),
      title: data.get(#title, or: $value.title),
      body: data.get(#body, or: $value.body),
      isDeleted: data.get(#isDeleted, or: $value.isDeleted),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      updatedAt: data.get(#updatedAt, or: $value.updatedAt),
      userProfile: data.get(#userProfile, or: $value.userProfile));

  @override
  DeckVoteReviewCopyWith<$R2, DeckVoteReview, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _DeckVoteReviewCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
