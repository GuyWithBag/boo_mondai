// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'survey_question.dto.dart';

class SurveyQuestionMapper extends ClassMapperBase<SurveyQuestion> {
  SurveyQuestionMapper._();

  static SurveyQuestionMapper? _instance;
  static SurveyQuestionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SurveyQuestionMapper._());
      SurveyTextQuestionMapper.ensureInitialized();
      SurveyNumberQuestionMapper.ensureInitialized();
      SurveyMultipleChoiceQuestionMapper.ensureInitialized();
      SurveyLikertQuestionMapper.ensureInitialized();
      SurveyBooleanQuestionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SurveyQuestion';

  static String _$id(SurveyQuestion v) => v.id;
  static const Field<SurveyQuestion, String> _f$id = Field('id', _$id);
  static String _$surveyId(SurveyQuestion v) => v.surveyId;
  static const Field<SurveyQuestion, String> _f$surveyId = Field(
    'surveyId',
    _$surveyId,
    key: r'survey_id',
  );
  static int _$position(SurveyQuestion v) => v.position;
  static const Field<SurveyQuestion, int> _f$position = Field(
    'position',
    _$position,
  );
  static String _$key(SurveyQuestion v) => v.key;
  static const Field<SurveyQuestion, String> _f$key = Field('key', _$key);
  static String _$title(SurveyQuestion v) => v.title;
  static const Field<SurveyQuestion, String> _f$title = Field('title', _$title);
  static String? _$description(SurveyQuestion v) => v.description;
  static const Field<SurveyQuestion, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
  );
  static bool _$isRequired(SurveyQuestion v) => v.isRequired;
  static const Field<SurveyQuestion, bool> _f$isRequired = Field(
    'isRequired',
    _$isRequired,
    key: r'is_required',
    opt: true,
    def: true,
  );

  @override
  final MappableFields<SurveyQuestion> fields = const {
    #id: _f$id,
    #surveyId: _f$surveyId,
    #position: _f$position,
    #key: _f$key,
    #title: _f$title,
    #description: _f$description,
    #isRequired: _f$isRequired,
  };

  static SurveyQuestion _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
      'SurveyQuestion',
      'question_type',
      '${data.value['question_type']}',
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SurveyQuestion fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SurveyQuestion>(map);
  }

  static SurveyQuestion fromJson(String json) {
    return ensureInitialized().decodeJson<SurveyQuestion>(json);
  }
}

mixin SurveyQuestionMappable {
  String toJson();
  Map<String, dynamic> toMap();
  SurveyQuestionCopyWith<SurveyQuestion, SurveyQuestion, SurveyQuestion>
  get copyWith;
}

abstract class SurveyQuestionCopyWith<$R, $In extends SurveyQuestion, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? surveyId,
    int? position,
    String? key,
    String? title,
    String? description,
    bool? isRequired,
  });
  SurveyQuestionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}
