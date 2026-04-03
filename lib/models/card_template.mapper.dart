// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'card_template.dart';

class CardTemplateMapper extends ClassMapperBase<CardTemplate> {
  CardTemplateMapper._();

  static CardTemplateMapper? _instance;
  static CardTemplateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CardTemplateMapper._());
      FillInTheBlanksTemplateMapper.ensureInitialized();
      IdentificationTemplateMapper.ensureInitialized();
      MatchMadnessTemplateMapper.ensureInitialized();
      FlashcardTemplateMapper.ensureInitialized();
      MultipleChoiceTemplateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'CardTemplate';

  static String _$id(CardTemplate v) => v.id;
  static const Field<CardTemplate, String> _f$id = Field('id', _$id);
  static String _$deckId(CardTemplate v) => v.deckId;
  static const Field<CardTemplate, String> _f$deckId =
      Field('deckId', _$deckId);
  static int _$sortOrder(CardTemplate v) => v.sortOrder;
  static const Field<CardTemplate, int> _f$sortOrder =
      Field('sortOrder', _$sortOrder);
  static DateTime _$createdAt(CardTemplate v) => v.createdAt;
  static const Field<CardTemplate, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt);
  static String? _$sourceTemplateId(CardTemplate v) => v.sourceTemplateId;
  static const Field<CardTemplate, String> _f$sourceTemplateId =
      Field('sourceTemplateId', _$sourceTemplateId, opt: true);

  @override
  final MappableFields<CardTemplate> fields = const {
    #id: _f$id,
    #deckId: _f$deckId,
    #sortOrder: _f$sortOrder,
    #createdAt: _f$createdAt,
    #sourceTemplateId: _f$sourceTemplateId,
  };

  static CardTemplate _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
        'CardTemplate', 'type', '${data.value['type']}');
  }

  @override
  final Function instantiate = _instantiate;

  static CardTemplate fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CardTemplate>(map);
  }

  static CardTemplate fromJson(String json) {
    return ensureInitialized().decodeJson<CardTemplate>(json);
  }
}

mixin CardTemplateMappable {
  String toJson();
  Map<String, dynamic> toMap();
  CardTemplateCopyWith<CardTemplate, CardTemplate, CardTemplate> get copyWith;
}

abstract class CardTemplateCopyWith<$R, $In extends CardTemplate, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? deckId,
      int? sortOrder,
      DateTime? createdAt,
      String? sourceTemplateId});
  CardTemplateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}
