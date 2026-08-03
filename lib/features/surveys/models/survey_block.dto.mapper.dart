// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'survey_block.dto.dart';

class SurveyBlockMapper extends ClassMapperBase<SurveyBlock> {
  SurveyBlockMapper._();

  static SurveyBlockMapper? _instance;
  static SurveyBlockMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SurveyBlockMapper._());
      SurveyContentBlockMapper.ensureInitialized();
      SurveyTextInputBlockMapper.ensureInitialized();
      SurveyNumberInputBlockMapper.ensureInitialized();
      SurveyMultipleChoiceInputBlockMapper.ensureInitialized();
      SurveyLikertInputBlockMapper.ensureInitialized();
      SurveyBooleanInputBlockMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SurveyBlock';

  static String _$id(SurveyBlock v) => v.id;
  static const Field<SurveyBlock, String> _f$id = Field('id', _$id);
  static String _$surveyId(SurveyBlock v) => v.surveyId;
  static const Field<SurveyBlock, String> _f$surveyId =
      Field('surveyId', _$surveyId, key: r'survey_id');
  static String _$pageId(SurveyBlock v) => v.pageId;
  static const Field<SurveyBlock, String> _f$pageId =
      Field('pageId', _$pageId, key: r'page_id');
  static int _$position(SurveyBlock v) => v.position;
  static const Field<SurveyBlock, int> _f$position =
      Field('position', _$position);

  @override
  final MappableFields<SurveyBlock> fields = const {
    #id: _f$id,
    #surveyId: _f$surveyId,
    #pageId: _f$pageId,
    #position: _f$position,
  };

  static SurveyBlock _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
        'SurveyBlock', 'block_type', '${data.value['block_type']}');
  }

  @override
  final Function instantiate = _instantiate;

  static SurveyBlock fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SurveyBlock>(map);
  }

  static SurveyBlock fromJson(String json) {
    return ensureInitialized().decodeJson<SurveyBlock>(json);
  }
}

mixin SurveyBlockMappable {
  String toJson();
  Map<String, dynamic> toMap();
  SurveyBlockCopyWith<SurveyBlock, SurveyBlock, SurveyBlock> get copyWith;
}

abstract class SurveyBlockCopyWith<$R, $In extends SurveyBlock, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? surveyId, String? pageId, int? position});
  SurveyBlockCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}
