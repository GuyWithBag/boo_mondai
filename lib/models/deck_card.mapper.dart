// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'deck_card.dart';

class DeckCardMapper extends ClassMapperBase<DeckCard> {
  DeckCardMapper._();

  static DeckCardMapper? _instance;
  static DeckCardMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = DeckCardMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'DeckCard';

  static String _$id(DeckCard v) => v.id;
  static const Field<DeckCard, String> _f$id = Field('id', _$id);
  static String _$deckId(DeckCard v) => v.deckId;
  static const Field<DeckCard, String> _f$deckId = Field('deckId', _$deckId);
  static CardType _$cardType(DeckCard v) => v.cardType;
  static const Field<DeckCard, CardType> _f$cardType =
      Field('cardType', _$cardType, opt: true, def: CardType.normal);
  static QuestionType _$questionType(DeckCard v) => v.questionType;
  static const Field<DeckCard, QuestionType> _f$questionType = Field(
      'questionType', _$questionType,
      opt: true, def: QuestionType.flashcard);
  static int _$sortOrder(DeckCard v) => v.sortOrder;
  static const Field<DeckCard, int> _f$sortOrder =
      Field('sortOrder', _$sortOrder);
  static DateTime _$createdAt(DeckCard v) => v.createdAt;
  static const Field<DeckCard, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);
  static String? _$sourceCardId(DeckCard v) => v.sourceCardId;
  static const Field<DeckCard, String> _f$sourceCardId =
      Field('sourceCardId', _$sourceCardId, opt: true);
  static String _$identificationAnswer(DeckCard v) => v.identificationAnswer;
  static const Field<DeckCard, String> _f$identificationAnswer =
      Field('identificationAnswer', _$identificationAnswer, opt: true, def: '');
  static List<Note> _$notes(DeckCard v) => v.notes;
  static const Field<DeckCard, List<Note>> _f$notes =
      Field('notes', _$notes, opt: true, def: const []);
  static List<MultipleChoiceOption> _$options(DeckCard v) => v.options;
  static const Field<DeckCard, List<MultipleChoiceOption>> _f$options =
      Field('options', _$options, opt: true, def: const []);
  static List<FillInTheBlankSegment> _$segments(DeckCard v) => v.segments;
  static const Field<DeckCard, List<FillInTheBlankSegment>> _f$segments =
      Field('segments', _$segments, opt: true, def: const []);
  static List<MatchMadnessPair> _$pairs(DeckCard v) => v.pairs;
  static const Field<DeckCard, List<MatchMadnessPair>> _f$pairs =
      Field('pairs', _$pairs, opt: true, def: const []);

  @override
  final MappableFields<DeckCard> fields = const {
    #id: _f$id,
    #deckId: _f$deckId,
    #cardType: _f$cardType,
    #questionType: _f$questionType,
    #sortOrder: _f$sortOrder,
    #createdAt: _f$createdAt,
    #sourceCardId: _f$sourceCardId,
    #identificationAnswer: _f$identificationAnswer,
    #notes: _f$notes,
    #options: _f$options,
    #segments: _f$segments,
    #pairs: _f$pairs,
  };

  static DeckCard _instantiate(DecodingData data) {
    return DeckCard(
        id: data.dec(_f$id),
        deckId: data.dec(_f$deckId),
        cardType: data.dec(_f$cardType),
        questionType: data.dec(_f$questionType),
        sortOrder: data.dec(_f$sortOrder),
        createdAt: data.dec(_f$createdAt),
        sourceCardId: data.dec(_f$sourceCardId),
        identificationAnswer: data.dec(_f$identificationAnswer),
        notes: data.dec(_f$notes),
        options: data.dec(_f$options),
        segments: data.dec(_f$segments),
        pairs: data.dec(_f$pairs));
  }

  @override
  final Function instantiate = _instantiate;

  static DeckCard fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<DeckCard>(map);
  }

  static DeckCard fromJson(String json) {
    return ensureInitialized().decodeJson<DeckCard>(json);
  }
}

mixin DeckCardMappable {
  String toJson() {
    return DeckCardMapper.ensureInitialized()
        .encodeJson<DeckCard>(this as DeckCard);
  }

  Map<String, dynamic> toMap() {
    return DeckCardMapper.ensureInitialized()
        .encodeMap<DeckCard>(this as DeckCard);
  }

  DeckCardCopyWith<DeckCard, DeckCard, DeckCard> get copyWith =>
      _DeckCardCopyWithImpl<DeckCard, DeckCard>(
          this as DeckCard, $identity, $identity);
  @override
  String toString() {
    return DeckCardMapper.ensureInitialized().stringifyValue(this as DeckCard);
  }

  @override
  bool operator ==(Object other) {
    return DeckCardMapper.ensureInitialized()
        .equalsValue(this as DeckCard, other);
  }

  @override
  int get hashCode {
    return DeckCardMapper.ensureInitialized().hashValue(this as DeckCard);
  }
}

extension DeckCardValueCopy<$R, $Out> on ObjectCopyWith<$R, DeckCard, $Out> {
  DeckCardCopyWith<$R, DeckCard, $Out> get $asDeckCard =>
      $base.as((v, t, t2) => _DeckCardCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class DeckCardCopyWith<$R, $In extends DeckCard, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Note, ObjectCopyWith<$R, Note, Note>> get notes;
  ListCopyWith<$R, MultipleChoiceOption,
          ObjectCopyWith<$R, MultipleChoiceOption, MultipleChoiceOption>>
      get options;
  ListCopyWith<$R, FillInTheBlankSegment,
          ObjectCopyWith<$R, FillInTheBlankSegment, FillInTheBlankSegment>>
      get segments;
  ListCopyWith<$R, MatchMadnessPair,
      ObjectCopyWith<$R, MatchMadnessPair, MatchMadnessPair>> get pairs;
  $R call(
      {String? id,
      String? deckId,
      CardType? cardType,
      QuestionType? questionType,
      int? sortOrder,
      DateTime? createdAt,
      String? sourceCardId,
      String? identificationAnswer,
      List<Note>? notes,
      List<MultipleChoiceOption>? options,
      List<FillInTheBlankSegment>? segments,
      List<MatchMadnessPair>? pairs});
  DeckCardCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _DeckCardCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, DeckCard, $Out>
    implements DeckCardCopyWith<$R, DeckCard, $Out> {
  _DeckCardCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<DeckCard> $mapper =
      DeckCardMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Note, ObjectCopyWith<$R, Note, Note>> get notes =>
      ListCopyWith($value.notes, (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(notes: v));
  @override
  ListCopyWith<$R, MultipleChoiceOption,
          ObjectCopyWith<$R, MultipleChoiceOption, MultipleChoiceOption>>
      get options => ListCopyWith($value.options,
          (v, t) => ObjectCopyWith(v, $identity, t), (v) => call(options: v));
  @override
  ListCopyWith<$R, FillInTheBlankSegment,
          ObjectCopyWith<$R, FillInTheBlankSegment, FillInTheBlankSegment>>
      get segments => ListCopyWith($value.segments,
          (v, t) => ObjectCopyWith(v, $identity, t), (v) => call(segments: v));
  @override
  ListCopyWith<$R, MatchMadnessPair,
          ObjectCopyWith<$R, MatchMadnessPair, MatchMadnessPair>>
      get pairs => ListCopyWith($value.pairs,
          (v, t) => ObjectCopyWith(v, $identity, t), (v) => call(pairs: v));
  @override
  $R call(
          {String? id,
          String? deckId,
          CardType? cardType,
          QuestionType? questionType,
          int? sortOrder,
          DateTime? createdAt,
          Object? sourceCardId = $none,
          String? identificationAnswer,
          List<Note>? notes,
          List<MultipleChoiceOption>? options,
          List<FillInTheBlankSegment>? segments,
          List<MatchMadnessPair>? pairs}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (deckId != null) #deckId: deckId,
        if (cardType != null) #cardType: cardType,
        if (questionType != null) #questionType: questionType,
        if (sortOrder != null) #sortOrder: sortOrder,
        if (createdAt != null) #createdAt: createdAt,
        if (sourceCardId != $none) #sourceCardId: sourceCardId,
        if (identificationAnswer != null)
          #identificationAnswer: identificationAnswer,
        if (notes != null) #notes: notes,
        if (options != null) #options: options,
        if (segments != null) #segments: segments,
        if (pairs != null) #pairs: pairs
      }));
  @override
  DeckCard $make(CopyWithData data) => DeckCard(
      id: data.get(#id, or: $value.id),
      deckId: data.get(#deckId, or: $value.deckId),
      cardType: data.get(#cardType, or: $value.cardType),
      questionType: data.get(#questionType, or: $value.questionType),
      sortOrder: data.get(#sortOrder, or: $value.sortOrder),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      sourceCardId: data.get(#sourceCardId, or: $value.sourceCardId),
      identificationAnswer:
          data.get(#identificationAnswer, or: $value.identificationAnswer),
      notes: data.get(#notes, or: $value.notes),
      options: data.get(#options, or: $value.options),
      segments: data.get(#segments, or: $value.segments),
      pairs: data.get(#pairs, or: $value.pairs));

  @override
  DeckCardCopyWith<$R2, DeckCard, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _DeckCardCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
