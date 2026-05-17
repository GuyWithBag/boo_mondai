// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'flashcard_template.dto.dart';

class FlashcardTemplateMapper extends SubClassMapperBase<FlashcardTemplate> {
  FlashcardTemplateMapper._();

  static FlashcardTemplateMapper? _instance;
  static FlashcardTemplateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FlashcardTemplateMapper._());
      CardTemplateMapper.ensureInitialized().addSubMapper(_instance!);
      CardTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FlashcardTemplate';

  static String _$id(FlashcardTemplate v) => v.id;
  static const Field<FlashcardTemplate, String> _f$id = Field('id', _$id);
  static String _$deckId(FlashcardTemplate v) => v.deckId;
  static const Field<FlashcardTemplate, String> _f$deckId = Field(
    'deckId',
    _$deckId,
    key: r'deck_id',
  );
  static int _$sortOrder(FlashcardTemplate v) => v.sortOrder;
  static const Field<FlashcardTemplate, int> _f$sortOrder = Field(
    'sortOrder',
    _$sortOrder,
    key: r'sort_order',
  );
  static DateTime _$createdAt(FlashcardTemplate v) => v.createdAt;
  static const Field<FlashcardTemplate, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );
  static DateTime _$updatedAt(FlashcardTemplate v) => v.updatedAt;
  static const Field<FlashcardTemplate, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );
  static String? _$sourceTemplateId(FlashcardTemplate v) => v.sourceTemplateId;
  static const Field<FlashcardTemplate, String> _f$sourceTemplateId = Field(
    'sourceTemplateId',
    _$sourceTemplateId,
    key: r'source_template_id',
    opt: true,
  );
  static String _$frontText(FlashcardTemplate v) => v.frontText;
  static const Field<FlashcardTemplate, String> _f$frontText = Field(
    'frontText',
    _$frontText,
    key: r'front_text',
  );
  static String _$backText(FlashcardTemplate v) => v.backText;
  static const Field<FlashcardTemplate, String> _f$backText = Field(
    'backText',
    _$backText,
    key: r'back_text',
  );
  static String? _$frontImageUrl(FlashcardTemplate v) => v.frontImageUrl;
  static const Field<FlashcardTemplate, String> _f$frontImageUrl = Field(
    'frontImageUrl',
    _$frontImageUrl,
    key: r'front_image_url',
    opt: true,
  );
  static String? _$backImageUrl(FlashcardTemplate v) => v.backImageUrl;
  static const Field<FlashcardTemplate, String> _f$backImageUrl = Field(
    'backImageUrl',
    _$backImageUrl,
    key: r'back_image_url',
    opt: true,
  );
  static String? _$frontAudioUrl(FlashcardTemplate v) => v.frontAudioUrl;
  static const Field<FlashcardTemplate, String> _f$frontAudioUrl = Field(
    'frontAudioUrl',
    _$frontAudioUrl,
    key: r'front_audio_url',
    opt: true,
  );
  static String? _$backAudioUrl(FlashcardTemplate v) => v.backAudioUrl;
  static const Field<FlashcardTemplate, String> _f$backAudioUrl = Field(
    'backAudioUrl',
    _$backAudioUrl,
    key: r'back_audio_url',
    opt: true,
  );
  static CardType _$cardType(FlashcardTemplate v) => v.cardType;
  static const Field<FlashcardTemplate, CardType> _f$cardType = Field(
    'cardType',
    _$cardType,
    key: r'card_type',
    opt: true,
    def: CardType.normal,
  );
  static List<Tag> _$tags(FlashcardTemplate v) => v.tags;
  static const Field<FlashcardTemplate, List<Tag>> _f$tags = Field(
    'tags',
    _$tags,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<FlashcardTemplate> fields = const {
    #id: _f$id,
    #deckId: _f$deckId,
    #sortOrder: _f$sortOrder,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #sourceTemplateId: _f$sourceTemplateId,
    #frontText: _f$frontText,
    #backText: _f$backText,
    #frontImageUrl: _f$frontImageUrl,
    #backImageUrl: _f$backImageUrl,
    #frontAudioUrl: _f$frontAudioUrl,
    #backAudioUrl: _f$backAudioUrl,
    #cardType: _f$cardType,
    #tags: _f$tags,
  };

  @override
  final String discriminatorKey = 'type';
  @override
  final dynamic discriminatorValue = 'flashcard';
  @override
  late final ClassMapperBase superMapper =
      CardTemplateMapper.ensureInitialized();

  static FlashcardTemplate _instantiate(DecodingData data) {
    return FlashcardTemplate(
      id: data.dec(_f$id),
      deckId: data.dec(_f$deckId),
      sortOrder: data.dec(_f$sortOrder),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
      sourceTemplateId: data.dec(_f$sourceTemplateId),
      frontText: data.dec(_f$frontText),
      backText: data.dec(_f$backText),
      frontImageUrl: data.dec(_f$frontImageUrl),
      backImageUrl: data.dec(_f$backImageUrl),
      frontAudioUrl: data.dec(_f$frontAudioUrl),
      backAudioUrl: data.dec(_f$backAudioUrl),
      cardType: data.dec(_f$cardType),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FlashcardTemplate fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FlashcardTemplate>(map);
  }

  static FlashcardTemplate fromJson(String json) {
    return ensureInitialized().decodeJson<FlashcardTemplate>(json);
  }
}

mixin FlashcardTemplateMappable {
  String toJson() {
    return FlashcardTemplateMapper.ensureInitialized()
        .encodeJson<FlashcardTemplate>(this as FlashcardTemplate);
  }

  Map<String, dynamic> toMap() {
    return FlashcardTemplateMapper.ensureInitialized()
        .encodeMap<FlashcardTemplate>(this as FlashcardTemplate);
  }

  FlashcardTemplateCopyWith<
    FlashcardTemplate,
    FlashcardTemplate,
    FlashcardTemplate
  >
  get copyWith =>
      _FlashcardTemplateCopyWithImpl<FlashcardTemplate, FlashcardTemplate>(
        this as FlashcardTemplate,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FlashcardTemplateMapper.ensureInitialized().stringifyValue(
      this as FlashcardTemplate,
    );
  }

  @override
  bool operator ==(Object other) {
    return FlashcardTemplateMapper.ensureInitialized().equalsValue(
      this as FlashcardTemplate,
      other,
    );
  }

  @override
  int get hashCode {
    return FlashcardTemplateMapper.ensureInitialized().hashValue(
      this as FlashcardTemplate,
    );
  }
}

extension FlashcardTemplateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FlashcardTemplate, $Out> {
  FlashcardTemplateCopyWith<$R, FlashcardTemplate, $Out>
  get $asFlashcardTemplate => $base.as(
    (v, t, t2) => _FlashcardTemplateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FlashcardTemplateCopyWith<
  $R,
  $In extends FlashcardTemplate,
  $Out
>
    implements CardTemplateCopyWith<$R, $In, $Out> {
  @override
  $R call({
    String? id,
    String? deckId,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? sourceTemplateId,
    String? frontText,
    String? backText,
    String? frontImageUrl,
    String? backImageUrl,
    String? frontAudioUrl,
    String? backAudioUrl,
    CardType? cardType,
  });
  FlashcardTemplateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FlashcardTemplateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FlashcardTemplate, $Out>
    implements FlashcardTemplateCopyWith<$R, FlashcardTemplate, $Out> {
  _FlashcardTemplateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FlashcardTemplate> $mapper =
      FlashcardTemplateMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? deckId,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? sourceTemplateId = $none,
    String? frontText,
    String? backText,
    Object? frontImageUrl = $none,
    Object? backImageUrl = $none,
    Object? frontAudioUrl = $none,
    Object? backAudioUrl = $none,
    CardType? cardType,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (deckId != null) #deckId: deckId,
      if (sortOrder != null) #sortOrder: sortOrder,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (sourceTemplateId != $none) #sourceTemplateId: sourceTemplateId,
      if (frontText != null) #frontText: frontText,
      if (backText != null) #backText: backText,
      if (frontImageUrl != $none) #frontImageUrl: frontImageUrl,
      if (backImageUrl != $none) #backImageUrl: backImageUrl,
      if (frontAudioUrl != $none) #frontAudioUrl: frontAudioUrl,
      if (backAudioUrl != $none) #backAudioUrl: backAudioUrl,
      if (cardType != null) #cardType: cardType,
    }),
  );
  @override
  FlashcardTemplate $make(CopyWithData data) => FlashcardTemplate(
    id: data.get(#id, or: $value.id),
    deckId: data.get(#deckId, or: $value.deckId),
    sortOrder: data.get(#sortOrder, or: $value.sortOrder),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    sourceTemplateId: data.get(#sourceTemplateId, or: $value.sourceTemplateId),
    frontText: data.get(#frontText, or: $value.frontText),
    backText: data.get(#backText, or: $value.backText),
    frontImageUrl: data.get(#frontImageUrl, or: $value.frontImageUrl),
    backImageUrl: data.get(#backImageUrl, or: $value.backImageUrl),
    frontAudioUrl: data.get(#frontAudioUrl, or: $value.frontAudioUrl),
    backAudioUrl: data.get(#backAudioUrl, or: $value.backAudioUrl),
    cardType: data.get(#cardType, or: $value.cardType),
  );

  @override
  FlashcardTemplateCopyWith<$R2, FlashcardTemplate, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FlashcardTemplateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
