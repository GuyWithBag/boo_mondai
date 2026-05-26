// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'review_card.dto.dart';

class ReviewCardMapper extends ClassMapperBase<ReviewCard> {
  ReviewCardMapper._();

  static ReviewCardMapper? _instance;
  static ReviewCardMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReviewCardMapper._());
      TagMapper.ensureInitialized();
      CardTemplateMapper.ensureInitialized();
      DeckMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ReviewCard';

  static String _$id(ReviewCard v) => v.id;
  static const Field<ReviewCard, String> _f$id = Field('id', _$id);
  static String _$templateId(ReviewCard v) => v.templateId;
  static const Field<ReviewCard, String> _f$templateId =
      Field('templateId', _$templateId, key: r'template_id');
  static bool _$isReversed(ReviewCard v) => v.isReversed;
  static const Field<ReviewCard, bool> _f$isReversed = Field(
      'isReversed', _$isReversed,
      key: r'is_reversed', opt: true, def: false);
  static String _$deckId(ReviewCard v) => v.deckId;
  static const Field<ReviewCard, String> _f$deckId =
      Field('deckId', _$deckId, key: r'deck_id');
  static List<Tag> _$personalTags(ReviewCard v) => v.personalTags;
  static const Field<ReviewCard, List<Tag>> _f$personalTags = Field(
      'personalTags', _$personalTags,
      key: r'personal_tags', opt: true, def: const []);
  static CardTemplate? _$template(ReviewCard v) => v.template;
  static const Field<ReviewCard, CardTemplate> _f$template =
      Field('template', _$template, opt: true);
  static Deck? _$deck(ReviewCard v) => v.deck;
  static const Field<ReviewCard, Deck> _f$deck =
      Field('deck', _$deck, opt: true);

  @override
  final MappableFields<ReviewCard> fields = const {
    #id: _f$id,
    #templateId: _f$templateId,
    #isReversed: _f$isReversed,
    #deckId: _f$deckId,
    #personalTags: _f$personalTags,
    #template: _f$template,
    #deck: _f$deck,
  };

  static ReviewCard _instantiate(DecodingData data) {
    return ReviewCard(
        id: data.dec(_f$id),
        templateId: data.dec(_f$templateId),
        isReversed: data.dec(_f$isReversed),
        deckId: data.dec(_f$deckId),
        personalTags: data.dec(_f$personalTags),
        template: data.dec(_f$template),
        deck: data.dec(_f$deck));
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
  ListCopyWith<$R, Tag, TagCopyWith<$R, Tag, Tag>> get personalTags;
  CardTemplateCopyWith<$R, CardTemplate, CardTemplate>? get template;
  DeckCopyWith<$R, Deck, Deck>? get deck;
  $R call(
      {String? id,
      String? templateId,
      bool? isReversed,
      String? deckId,
      List<Tag>? personalTags,
      CardTemplate? template,
      Deck? deck});
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
  ListCopyWith<$R, Tag, TagCopyWith<$R, Tag, Tag>> get personalTags =>
      ListCopyWith($value.personalTags, (v, t) => v.copyWith.$chain(t),
          (v) => call(personalTags: v));
  @override
  CardTemplateCopyWith<$R, CardTemplate, CardTemplate>? get template =>
      $value.template?.copyWith.$chain((v) => call(template: v));
  @override
  DeckCopyWith<$R, Deck, Deck>? get deck =>
      $value.deck?.copyWith.$chain((v) => call(deck: v));
  @override
  $R call(
          {String? id,
          String? templateId,
          bool? isReversed,
          String? deckId,
          List<Tag>? personalTags,
          Object? template = $none,
          Object? deck = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (templateId != null) #templateId: templateId,
        if (isReversed != null) #isReversed: isReversed,
        if (deckId != null) #deckId: deckId,
        if (personalTags != null) #personalTags: personalTags,
        if (template != $none) #template: template,
        if (deck != $none) #deck: deck
      }));
  @override
  ReviewCard $make(CopyWithData data) => ReviewCard(
      id: data.get(#id, or: $value.id),
      templateId: data.get(#templateId, or: $value.templateId),
      isReversed: data.get(#isReversed, or: $value.isReversed),
      deckId: data.get(#deckId, or: $value.deckId),
      personalTags: data.get(#personalTags, or: $value.personalTags),
      template: data.get(#template, or: $value.template),
      deck: data.get(#deck, or: $value.deck));

  @override
  ReviewCardCopyWith<$R2, ReviewCard, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _ReviewCardCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
