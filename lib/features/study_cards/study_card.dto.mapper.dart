// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'study_card.dto.dart';

class StudyCardMapper extends ClassMapperBase<StudyCard> {
  StudyCardMapper._();

  static StudyCardMapper? _instance;
  static StudyCardMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StudyCardMapper._());
      MutableEntityMapper.ensureInitialized();
      TagMapper.ensureInitialized();
      CardTemplateMapper.ensureInitialized();
      DeckMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'StudyCard';

  static String _$id(StudyCard v) => v.id;
  static const Field<StudyCard, String> _f$id = Field('id', _$id);
  static DateTime _$createdAt(StudyCard v) => v.createdAt;
  static const Field<StudyCard, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );
  static DateTime _$updatedAt(StudyCard v) => v.updatedAt;
  static const Field<StudyCard, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );
  static String _$templateId(StudyCard v) => v.templateId;
  static const Field<StudyCard, String> _f$templateId = Field(
    'templateId',
    _$templateId,
    key: r'template_id',
  );
  static bool _$isReversed(StudyCard v) => v.isReversed;
  static const Field<StudyCard, bool> _f$isReversed = Field(
    'isReversed',
    _$isReversed,
    key: r'is_reversed',
    opt: true,
    def: false,
  );
  static String _$deckId(StudyCard v) => v.deckId;
  static const Field<StudyCard, String> _f$deckId = Field(
    'deckId',
    _$deckId,
    key: r'deck_id',
  );
  static List<Tag> _$personalTags(StudyCard v) => v.personalTags;
  static const Field<StudyCard, List<Tag>> _f$personalTags = Field(
    'personalTags',
    _$personalTags,
    key: r'personal_tags',
    opt: true,
    def: const [],
  );
  static CardTemplate? _$template(StudyCard v) => v.template;
  static const Field<StudyCard, CardTemplate> _f$template = Field(
    'template',
    _$template,
    opt: true,
  );
  static Deck? _$deck(StudyCard v) => v.deck;
  static const Field<StudyCard, Deck> _f$deck = Field(
    'deck',
    _$deck,
    opt: true,
  );

  @override
  final MappableFields<StudyCard> fields = const {
    #id: _f$id,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #templateId: _f$templateId,
    #isReversed: _f$isReversed,
    #deckId: _f$deckId,
    #personalTags: _f$personalTags,
    #template: _f$template,
    #deck: _f$deck,
  };

  static StudyCard _instantiate(DecodingData data) {
    return StudyCard(
      id: data.dec(_f$id),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
      templateId: data.dec(_f$templateId),
      isReversed: data.dec(_f$isReversed),
      deckId: data.dec(_f$deckId),
      personalTags: data.dec(_f$personalTags),
      template: data.dec(_f$template),
      deck: data.dec(_f$deck),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static StudyCard fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<StudyCard>(map);
  }

  static StudyCard fromJson(String json) {
    return ensureInitialized().decodeJson<StudyCard>(json);
  }
}

mixin StudyCardMappable {
  String toJson() {
    return StudyCardMapper.ensureInitialized().encodeJson<StudyCard>(
      this as StudyCard,
    );
  }

  Map<String, dynamic> toMap() {
    return StudyCardMapper.ensureInitialized().encodeMap<StudyCard>(
      this as StudyCard,
    );
  }

  StudyCardCopyWith<StudyCard, StudyCard, StudyCard> get copyWith =>
      _StudyCardCopyWithImpl<StudyCard, StudyCard>(
        this as StudyCard,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return StudyCardMapper.ensureInitialized().stringifyValue(
      this as StudyCard,
    );
  }

  @override
  bool operator ==(Object other) {
    return StudyCardMapper.ensureInitialized().equalsValue(
      this as StudyCard,
      other,
    );
  }

  @override
  int get hashCode {
    return StudyCardMapper.ensureInitialized().hashValue(this as StudyCard);
  }
}

extension StudyCardValueCopy<$R, $Out> on ObjectCopyWith<$R, StudyCard, $Out> {
  StudyCardCopyWith<$R, StudyCard, $Out> get $asStudyCard =>
      $base.as((v, t, t2) => _StudyCardCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class StudyCardCopyWith<$R, $In extends StudyCard, $Out>
    implements MutableEntityCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Tag, TagCopyWith<$R, Tag, Tag>> get personalTags;
  CardTemplateCopyWith<$R, CardTemplate, CardTemplate>? get template;
  DeckCopyWith<$R, Deck, Deck>? get deck;
  @override
  $R call({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? templateId,
    bool? isReversed,
    String? deckId,
    List<Tag>? personalTags,
    CardTemplate? template,
    Deck? deck,
  });
  StudyCardCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _StudyCardCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, StudyCard, $Out>
    implements StudyCardCopyWith<$R, StudyCard, $Out> {
  _StudyCardCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<StudyCard> $mapper =
      StudyCardMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Tag, TagCopyWith<$R, Tag, Tag>> get personalTags =>
      ListCopyWith(
        $value.personalTags,
        (v, t) => v.copyWith.$chain(t),
        (v) => call(personalTags: v),
      );
  @override
  CardTemplateCopyWith<$R, CardTemplate, CardTemplate>? get template =>
      $value.template?.copyWith.$chain((v) => call(template: v));
  @override
  DeckCopyWith<$R, Deck, Deck>? get deck =>
      $value.deck?.copyWith.$chain((v) => call(deck: v));
  @override
  $R call({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? templateId,
    bool? isReversed,
    String? deckId,
    List<Tag>? personalTags,
    Object? template = $none,
    Object? deck = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (templateId != null) #templateId: templateId,
      if (isReversed != null) #isReversed: isReversed,
      if (deckId != null) #deckId: deckId,
      if (personalTags != null) #personalTags: personalTags,
      if (template != $none) #template: template,
      if (deck != $none) #deck: deck,
    }),
  );
  @override
  StudyCard $make(CopyWithData data) => StudyCard(
    id: data.get(#id, or: $value.id),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    templateId: data.get(#templateId, or: $value.templateId),
    isReversed: data.get(#isReversed, or: $value.isReversed),
    deckId: data.get(#deckId, or: $value.deckId),
    personalTags: data.get(#personalTags, or: $value.personalTags),
    template: data.get(#template, or: $value.template),
    deck: data.get(#deck, or: $value.deck),
  );

  @override
  StudyCardCopyWith<$R2, StudyCard, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _StudyCardCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
