// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_review_card_tag.dto.dart';

class UserReviewCardTagMapper extends ClassMapperBase<UserReviewCardTag> {
  UserReviewCardTagMapper._();

  static UserReviewCardTagMapper? _instance;
  static UserReviewCardTagMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserReviewCardTagMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserReviewCardTag';

  static String _$userId(UserReviewCardTag v) => v.userId;
  static const Field<UserReviewCardTag, String> _f$userId = Field(
    'userId',
    _$userId,
    key: r'user_id',
  );
  static String _$reviewCardId(UserReviewCardTag v) => v.reviewCardId;
  static const Field<UserReviewCardTag, String> _f$reviewCardId = Field(
    'reviewCardId',
    _$reviewCardId,
    key: r'review_card_id',
  );
  static String _$tagId(UserReviewCardTag v) => v.tagId;
  static const Field<UserReviewCardTag, String> _f$tagId = Field(
    'tagId',
    _$tagId,
    key: r'tag_id',
  );

  @override
  final MappableFields<UserReviewCardTag> fields = const {
    #userId: _f$userId,
    #reviewCardId: _f$reviewCardId,
    #tagId: _f$tagId,
  };

  static UserReviewCardTag _instantiate(DecodingData data) {
    return UserReviewCardTag(
      userId: data.dec(_f$userId),
      reviewCardId: data.dec(_f$reviewCardId),
      tagId: data.dec(_f$tagId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserReviewCardTag fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserReviewCardTag>(map);
  }

  static UserReviewCardTag fromJson(String json) {
    return ensureInitialized().decodeJson<UserReviewCardTag>(json);
  }
}

mixin UserReviewCardTagMappable {
  String toJson() {
    return UserReviewCardTagMapper.ensureInitialized()
        .encodeJson<UserReviewCardTag>(this as UserReviewCardTag);
  }

  Map<String, dynamic> toMap() {
    return UserReviewCardTagMapper.ensureInitialized()
        .encodeMap<UserReviewCardTag>(this as UserReviewCardTag);
  }

  UserReviewCardTagCopyWith<
    UserReviewCardTag,
    UserReviewCardTag,
    UserReviewCardTag
  >
  get copyWith =>
      _UserReviewCardTagCopyWithImpl<UserReviewCardTag, UserReviewCardTag>(
        this as UserReviewCardTag,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return UserReviewCardTagMapper.ensureInitialized().stringifyValue(
      this as UserReviewCardTag,
    );
  }

  @override
  bool operator ==(Object other) {
    return UserReviewCardTagMapper.ensureInitialized().equalsValue(
      this as UserReviewCardTag,
      other,
    );
  }

  @override
  int get hashCode {
    return UserReviewCardTagMapper.ensureInitialized().hashValue(
      this as UserReviewCardTag,
    );
  }
}

extension UserReviewCardTagValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserReviewCardTag, $Out> {
  UserReviewCardTagCopyWith<$R, UserReviewCardTag, $Out>
  get $asUserReviewCardTag => $base.as(
    (v, t, t2) => _UserReviewCardTagCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class UserReviewCardTagCopyWith<
  $R,
  $In extends UserReviewCardTag,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? userId, String? reviewCardId, String? tagId});
  UserReviewCardTagCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _UserReviewCardTagCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserReviewCardTag, $Out>
    implements UserReviewCardTagCopyWith<$R, UserReviewCardTag, $Out> {
  _UserReviewCardTagCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserReviewCardTag> $mapper =
      UserReviewCardTagMapper.ensureInitialized();
  @override
  $R call({String? userId, String? reviewCardId, String? tagId}) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (reviewCardId != null) #reviewCardId: reviewCardId,
      if (tagId != null) #tagId: tagId,
    }),
  );
  @override
  UserReviewCardTag $make(CopyWithData data) => UserReviewCardTag(
    userId: data.get(#userId, or: $value.userId),
    reviewCardId: data.get(#reviewCardId, or: $value.reviewCardId),
    tagId: data.get(#tagId, or: $value.tagId),
  );

  @override
  UserReviewCardTagCopyWith<$R2, UserReviewCardTag, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UserReviewCardTagCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
