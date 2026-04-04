// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'review_session.dart';

class ReviewSessionMapper extends SubClassMapperBase<ReviewSession> {
  ReviewSessionMapper._();

  static ReviewSessionMapper? _instance;
  static ReviewSessionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReviewSessionMapper._());
      StudySessionMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'ReviewSession';

  static String _$id(ReviewSession v) => v.id;
  static const Field<ReviewSession, String> _f$id = Field('id', _$id);
  static String _$userId(ReviewSession v) => v.userId;
  static const Field<ReviewSession, String> _f$userId =
      Field('userId', _$userId);
  static String? _$deckId(ReviewSession v) => v.deckId;
  static const Field<ReviewSession, String> _f$deckId =
      Field('deckId', _$deckId, opt: true);
  static DateTime _$startedAt(ReviewSession v) => v.startedAt;
  static const Field<ReviewSession, DateTime> _f$startedAt =
      Field('startedAt', _$startedAt);
  static DateTime? _$completedAt(ReviewSession v) => v.completedAt;
  static const Field<ReviewSession, DateTime> _f$completedAt =
      Field('completedAt', _$completedAt, opt: true);
  static int _$totalCards(ReviewSession v) => v.totalCards;
  static const Field<ReviewSession, int> _f$totalCards =
      Field('totalCards', _$totalCards);
  static int _$cardsReviewed(ReviewSession v) => v.cardsReviewed;
  static const Field<ReviewSession, int> _f$cardsReviewed =
      Field('cardsReviewed', _$cardsReviewed, opt: true, def: 0);

  @override
  final MappableFields<ReviewSession> fields = const {
    #id: _f$id,
    #userId: _f$userId,
    #deckId: _f$deckId,
    #startedAt: _f$startedAt,
    #completedAt: _f$completedAt,
    #totalCards: _f$totalCards,
    #cardsReviewed: _f$cardsReviewed,
  };

  @override
  final String discriminatorKey = 'session_type';
  @override
  final dynamic discriminatorValue = 'ReviewSession';
  @override
  late final ClassMapperBase superMapper =
      StudySessionMapper.ensureInitialized();

  static ReviewSession _instantiate(DecodingData data) {
    return ReviewSession(
        id: data.dec(_f$id),
        userId: data.dec(_f$userId),
        deckId: data.dec(_f$deckId),
        startedAt: data.dec(_f$startedAt),
        completedAt: data.dec(_f$completedAt),
        totalCards: data.dec(_f$totalCards),
        cardsReviewed: data.dec(_f$cardsReviewed));
  }

  @override
  final Function instantiate = _instantiate;

  static ReviewSession fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ReviewSession>(map);
  }

  static ReviewSession fromJson(String json) {
    return ensureInitialized().decodeJson<ReviewSession>(json);
  }
}

mixin ReviewSessionMappable {
  String toJson() {
    return ReviewSessionMapper.ensureInitialized()
        .encodeJson<ReviewSession>(this as ReviewSession);
  }

  Map<String, dynamic> toMap() {
    return ReviewSessionMapper.ensureInitialized()
        .encodeMap<ReviewSession>(this as ReviewSession);
  }

  ReviewSessionCopyWith<ReviewSession, ReviewSession, ReviewSession>
      get copyWith => _ReviewSessionCopyWithImpl<ReviewSession, ReviewSession>(
          this as ReviewSession, $identity, $identity);
  @override
  String toString() {
    return ReviewSessionMapper.ensureInitialized()
        .stringifyValue(this as ReviewSession);
  }

  @override
  bool operator ==(Object other) {
    return ReviewSessionMapper.ensureInitialized()
        .equalsValue(this as ReviewSession, other);
  }

  @override
  int get hashCode {
    return ReviewSessionMapper.ensureInitialized()
        .hashValue(this as ReviewSession);
  }
}

extension ReviewSessionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ReviewSession, $Out> {
  ReviewSessionCopyWith<$R, ReviewSession, $Out> get $asReviewSession =>
      $base.as((v, t, t2) => _ReviewSessionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ReviewSessionCopyWith<$R, $In extends ReviewSession, $Out>
    implements StudySessionCopyWith<$R, $In, $Out> {
  @override
  $R call(
      {String? id,
      String? userId,
      String? deckId,
      DateTime? startedAt,
      DateTime? completedAt,
      int? totalCards,
      int? cardsReviewed});
  ReviewSessionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ReviewSessionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ReviewSession, $Out>
    implements ReviewSessionCopyWith<$R, ReviewSession, $Out> {
  _ReviewSessionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ReviewSession> $mapper =
      ReviewSessionMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? userId,
          Object? deckId = $none,
          DateTime? startedAt,
          Object? completedAt = $none,
          int? totalCards,
          int? cardsReviewed}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (userId != null) #userId: userId,
        if (deckId != $none) #deckId: deckId,
        if (startedAt != null) #startedAt: startedAt,
        if (completedAt != $none) #completedAt: completedAt,
        if (totalCards != null) #totalCards: totalCards,
        if (cardsReviewed != null) #cardsReviewed: cardsReviewed
      }));
  @override
  ReviewSession $make(CopyWithData data) => ReviewSession(
      id: data.get(#id, or: $value.id),
      userId: data.get(#userId, or: $value.userId),
      deckId: data.get(#deckId, or: $value.deckId),
      startedAt: data.get(#startedAt, or: $value.startedAt),
      completedAt: data.get(#completedAt, or: $value.completedAt),
      totalCards: data.get(#totalCards, or: $value.totalCards),
      cardsReviewed: data.get(#cardsReviewed, or: $value.cardsReviewed));

  @override
  ReviewSessionCopyWith<$R2, ReviewSession, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ReviewSessionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
