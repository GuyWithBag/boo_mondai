// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_deck_progress.dart';

class UserDeckProgressMapper extends ClassMapperBase<UserDeckProgress> {
  UserDeckProgressMapper._();

  static UserDeckProgressMapper? _instance;
  static UserDeckProgressMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserDeckProgressMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserDeckProgress';

  static String _$id(UserDeckProgress v) => v.id;
  static const Field<UserDeckProgress, String> _f$id = Field('id', _$id);
  static String _$userId(UserDeckProgress v) => v.userId;
  static const Field<UserDeckProgress, String> _f$userId =
      Field('userId', _$userId);
  static String _$deckId(UserDeckProgress v) => v.deckId;
  static const Field<UserDeckProgress, String> _f$deckId =
      Field('deckId', _$deckId);
  static int _$newCardsCount(UserDeckProgress v) => v.newCardsCount;
  static const Field<UserDeckProgress, int> _f$newCardsCount =
      Field('newCardsCount', _$newCardsCount, opt: true, def: 0);
  static int _$learningCardsCount(UserDeckProgress v) => v.learningCardsCount;
  static const Field<UserDeckProgress, int> _f$learningCardsCount =
      Field('learningCardsCount', _$learningCardsCount, opt: true, def: 0);
  static int _$reviewCardsCount(UserDeckProgress v) => v.reviewCardsCount;
  static const Field<UserDeckProgress, int> _f$reviewCardsCount =
      Field('reviewCardsCount', _$reviewCardsCount, opt: true, def: 0);
  static int _$totalDrilled(UserDeckProgress v) => v.totalDrilled;
  static const Field<UserDeckProgress, int> _f$totalDrilled =
      Field('totalDrilled', _$totalDrilled, opt: true, def: 0);
  static DateTime _$lastStudiedAt(UserDeckProgress v) => v.lastStudiedAt;
  static const Field<UserDeckProgress, DateTime> _f$lastStudiedAt =
      Field('lastStudiedAt', _$lastStudiedAt);

  @override
  final MappableFields<UserDeckProgress> fields = const {
    #id: _f$id,
    #userId: _f$userId,
    #deckId: _f$deckId,
    #newCardsCount: _f$newCardsCount,
    #learningCardsCount: _f$learningCardsCount,
    #reviewCardsCount: _f$reviewCardsCount,
    #totalDrilled: _f$totalDrilled,
    #lastStudiedAt: _f$lastStudiedAt,
  };

  static UserDeckProgress _instantiate(DecodingData data) {
    return UserDeckProgress(
        id: data.dec(_f$id),
        userId: data.dec(_f$userId),
        deckId: data.dec(_f$deckId),
        newCardsCount: data.dec(_f$newCardsCount),
        learningCardsCount: data.dec(_f$learningCardsCount),
        reviewCardsCount: data.dec(_f$reviewCardsCount),
        totalDrilled: data.dec(_f$totalDrilled),
        lastStudiedAt: data.dec(_f$lastStudiedAt));
  }

  @override
  final Function instantiate = _instantiate;

  static UserDeckProgress fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserDeckProgress>(map);
  }

  static UserDeckProgress fromJson(String json) {
    return ensureInitialized().decodeJson<UserDeckProgress>(json);
  }
}

mixin UserDeckProgressMappable {
  String toJson() {
    return UserDeckProgressMapper.ensureInitialized()
        .encodeJson<UserDeckProgress>(this as UserDeckProgress);
  }

  Map<String, dynamic> toMap() {
    return UserDeckProgressMapper.ensureInitialized()
        .encodeMap<UserDeckProgress>(this as UserDeckProgress);
  }

  UserDeckProgressCopyWith<UserDeckProgress, UserDeckProgress, UserDeckProgress>
      get copyWith =>
          _UserDeckProgressCopyWithImpl<UserDeckProgress, UserDeckProgress>(
              this as UserDeckProgress, $identity, $identity);
  @override
  String toString() {
    return UserDeckProgressMapper.ensureInitialized()
        .stringifyValue(this as UserDeckProgress);
  }

  @override
  bool operator ==(Object other) {
    return UserDeckProgressMapper.ensureInitialized()
        .equalsValue(this as UserDeckProgress, other);
  }

  @override
  int get hashCode {
    return UserDeckProgressMapper.ensureInitialized()
        .hashValue(this as UserDeckProgress);
  }
}

extension UserDeckProgressValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserDeckProgress, $Out> {
  UserDeckProgressCopyWith<$R, UserDeckProgress, $Out>
      get $asUserDeckProgress => $base
          .as((v, t, t2) => _UserDeckProgressCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserDeckProgressCopyWith<$R, $In extends UserDeckProgress, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? userId,
      String? deckId,
      int? newCardsCount,
      int? learningCardsCount,
      int? reviewCardsCount,
      int? totalDrilled,
      DateTime? lastStudiedAt});
  UserDeckProgressCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _UserDeckProgressCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserDeckProgress, $Out>
    implements UserDeckProgressCopyWith<$R, UserDeckProgress, $Out> {
  _UserDeckProgressCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserDeckProgress> $mapper =
      UserDeckProgressMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? userId,
          String? deckId,
          int? newCardsCount,
          int? learningCardsCount,
          int? reviewCardsCount,
          int? totalDrilled,
          DateTime? lastStudiedAt}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (userId != null) #userId: userId,
        if (deckId != null) #deckId: deckId,
        if (newCardsCount != null) #newCardsCount: newCardsCount,
        if (learningCardsCount != null) #learningCardsCount: learningCardsCount,
        if (reviewCardsCount != null) #reviewCardsCount: reviewCardsCount,
        if (totalDrilled != null) #totalDrilled: totalDrilled,
        if (lastStudiedAt != null) #lastStudiedAt: lastStudiedAt
      }));
  @override
  UserDeckProgress $make(CopyWithData data) => UserDeckProgress(
      id: data.get(#id, or: $value.id),
      userId: data.get(#userId, or: $value.userId),
      deckId: data.get(#deckId, or: $value.deckId),
      newCardsCount: data.get(#newCardsCount, or: $value.newCardsCount),
      learningCardsCount:
          data.get(#learningCardsCount, or: $value.learningCardsCount),
      reviewCardsCount:
          data.get(#reviewCardsCount, or: $value.reviewCardsCount),
      totalDrilled: data.get(#totalDrilled, or: $value.totalDrilled),
      lastStudiedAt: data.get(#lastStudiedAt, or: $value.lastStudiedAt));

  @override
  UserDeckProgressCopyWith<$R2, UserDeckProgress, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _UserDeckProgressCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
