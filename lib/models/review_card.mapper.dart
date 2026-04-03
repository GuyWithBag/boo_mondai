// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'review_card.dart';

class ReviewCardMapper extends ClassMapperBase<ReviewCard> {
  ReviewCardMapper._();

  static ReviewCardMapper? _instance;
  static ReviewCardMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReviewCardMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ReviewCard';

  static String _$id(ReviewCard v) => v.id;
  static const Field<ReviewCard, String> _f$id = Field('id', _$id);
  static String _$templateId(ReviewCard v) => v.templateId;
  static const Field<ReviewCard, String> _f$templateId =
      Field('templateId', _$templateId);
  static bool _$isReversed(ReviewCard v) => v.isReversed;
  static const Field<ReviewCard, bool> _f$isReversed =
      Field('isReversed', _$isReversed, opt: true, def: false);
  static String _$deckId(ReviewCard v) => v.deckId;
  static const Field<ReviewCard, String> _f$deckId = Field('deckId', _$deckId);

  @override
  final MappableFields<ReviewCard> fields = const {
    #id: _f$id,
    #templateId: _f$templateId,
    #isReversed: _f$isReversed,
    #deckId: _f$deckId,
  };

  static ReviewCard _instantiate(DecodingData data) {
    return ReviewCard(
        id: data.dec(_f$id),
        templateId: data.dec(_f$templateId),
        isReversed: data.dec(_f$isReversed),
        deckId: data.dec(_f$deckId));
  }

  @override
  final Function instantiate = _instantiate;

  static ReviewCard fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ReviewCard>(map);
  }

  static ReviewCard fromJson(String json) {
    return ensureInitialized().decodeJson<ReviewCard>(json);
  }
}

mixin ReviewCardMappable {
  String toJson() {
    return ReviewCardMapper.ensureInitialized()
        .encodeJson<ReviewCard>(this as ReviewCard);
  }

  Map<String, dynamic> toMap() {
    return ReviewCardMapper.ensureInitialized()
        .encodeMap<ReviewCard>(this as ReviewCard);
  }

  ReviewCardCopyWith<ReviewCard, ReviewCard, ReviewCard> get copyWith =>
      _ReviewCardCopyWithImpl<ReviewCard, ReviewCard>(
          this as ReviewCard, $identity, $identity);
  @override
  String toString() {
    return ReviewCardMapper.ensureInitialized()
        .stringifyValue(this as ReviewCard);
  }

  @override
  bool operator ==(Object other) {
    return ReviewCardMapper.ensureInitialized()
        .equalsValue(this as ReviewCard, other);
  }

  @override
  int get hashCode {
    return ReviewCardMapper.ensureInitialized().hashValue(this as ReviewCard);
  }
}

extension ReviewCardValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ReviewCard, $Out> {
  ReviewCardCopyWith<$R, ReviewCard, $Out> get $asReviewCard =>
      $base.as((v, t, t2) => _ReviewCardCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ReviewCardCopyWith<$R, $In extends ReviewCard, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? templateId, bool? isReversed, String? deckId});
  ReviewCardCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ReviewCardCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ReviewCard, $Out>
    implements ReviewCardCopyWith<$R, ReviewCard, $Out> {
  _ReviewCardCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ReviewCard> $mapper =
      ReviewCardMapper.ensureInitialized();
  @override
  $R call({String? id, String? templateId, bool? isReversed, String? deckId}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (templateId != null) #templateId: templateId,
        if (isReversed != null) #isReversed: isReversed,
        if (deckId != null) #deckId: deckId
      }));
  @override
  ReviewCard $make(CopyWithData data) => ReviewCard(
      id: data.get(#id, or: $value.id),
      templateId: data.get(#templateId, or: $value.templateId),
      isReversed: data.get(#isReversed, or: $value.isReversed),
      deckId: data.get(#deckId, or: $value.deckId));

  @override
  ReviewCardCopyWith<$R2, ReviewCard, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ReviewCardCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
