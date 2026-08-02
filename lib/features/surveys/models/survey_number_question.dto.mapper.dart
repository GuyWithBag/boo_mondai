// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'survey_number_question.dto.dart';

class SurveyNumberQuestionMapper
    extends SubClassMapperBase<SurveyNumberQuestion> {
  SurveyNumberQuestionMapper._();

  static SurveyNumberQuestionMapper? _instance;
  static SurveyNumberQuestionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SurveyNumberQuestionMapper._());
      SurveyQuestionMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'SurveyNumberQuestion';

  static String _$id(SurveyNumberQuestion v) => v.id;
  static const Field<SurveyNumberQuestion, String> _f$id = Field('id', _$id);
  static String _$surveyId(SurveyNumberQuestion v) => v.surveyId;
  static const Field<SurveyNumberQuestion, String> _f$surveyId = Field(
    'surveyId',
    _$surveyId,
    key: r'survey_id',
  );
  static int _$position(SurveyNumberQuestion v) => v.position;
  static const Field<SurveyNumberQuestion, int> _f$position = Field(
    'position',
    _$position,
  );
  static String _$key(SurveyNumberQuestion v) => v.key;
  static const Field<SurveyNumberQuestion, String> _f$key = Field('key', _$key);
  static String _$title(SurveyNumberQuestion v) => v.title;
  static const Field<SurveyNumberQuestion, String> _f$title = Field(
    'title',
    _$title,
  );
  static String? _$description(SurveyNumberQuestion v) => v.description;
  static const Field<SurveyNumberQuestion, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
  );
  static bool _$isRequired(SurveyNumberQuestion v) => v.isRequired;
  static const Field<SurveyNumberQuestion, bool> _f$isRequired = Field(
    'isRequired',
    _$isRequired,
    key: r'is_required',
    opt: true,
    def: true,
  );
  static num? _$minValue(SurveyNumberQuestion v) => v.minValue;
  static const Field<SurveyNumberQuestion, num> _f$minValue = Field(
    'minValue',
    _$minValue,
    key: r'min_value',
    opt: true,
  );
  static num? _$maxValue(SurveyNumberQuestion v) => v.maxValue;
  static const Field<SurveyNumberQuestion, num> _f$maxValue = Field(
    'maxValue',
    _$maxValue,
    key: r'max_value',
    opt: true,
  );
  static num? _$step(SurveyNumberQuestion v) => v.step;
  static const Field<SurveyNumberQuestion, num> _f$step = Field(
    'step',
    _$step,
    opt: true,
  );

  @override
  final MappableFields<SurveyNumberQuestion> fields = const {
    #id: _f$id,
    #surveyId: _f$surveyId,
    #position: _f$position,
    #key: _f$key,
    #title: _f$title,
    #description: _f$description,
    #isRequired: _f$isRequired,
    #minValue: _f$minValue,
    #maxValue: _f$maxValue,
    #step: _f$step,
  };

  @override
  final String discriminatorKey = 'question_type';
  @override
  final dynamic discriminatorValue = 'number';
  @override
  late final ClassMapperBase superMapper =
      SurveyQuestionMapper.ensureInitialized();

  static SurveyNumberQuestion _instantiate(DecodingData data) {
    return SurveyNumberQuestion(
      id: data.dec(_f$id),
      surveyId: data.dec(_f$surveyId),
      position: data.dec(_f$position),
      key: data.dec(_f$key),
      title: data.dec(_f$title),
      description: data.dec(_f$description),
      isRequired: data.dec(_f$isRequired),
      minValue: data.dec(_f$minValue),
      maxValue: data.dec(_f$maxValue),
      step: data.dec(_f$step),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SurveyNumberQuestion fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SurveyNumberQuestion>(map);
  }

  static SurveyNumberQuestion fromJson(String json) {
    return ensureInitialized().decodeJson<SurveyNumberQuestion>(json);
  }
}

mixin SurveyNumberQuestionMappable {
  String toJson() {
    return SurveyNumberQuestionMapper.ensureInitialized()
        .encodeJson<SurveyNumberQuestion>(this as SurveyNumberQuestion);
  }

  Map<String, dynamic> toMap() {
    return SurveyNumberQuestionMapper.ensureInitialized()
        .encodeMap<SurveyNumberQuestion>(this as SurveyNumberQuestion);
  }

  SurveyNumberQuestionCopyWith<
    SurveyNumberQuestion,
    SurveyNumberQuestion,
    SurveyNumberQuestion
  >
  get copyWith =>
      _SurveyNumberQuestionCopyWithImpl<
        SurveyNumberQuestion,
        SurveyNumberQuestion
      >(this as SurveyNumberQuestion, $identity, $identity);
  @override
  String toString() {
    return SurveyNumberQuestionMapper.ensureInitialized().stringifyValue(
      this as SurveyNumberQuestion,
    );
  }

  @override
  bool operator ==(Object other) {
    return SurveyNumberQuestionMapper.ensureInitialized().equalsValue(
      this as SurveyNumberQuestion,
      other,
    );
  }

  @override
  int get hashCode {
    return SurveyNumberQuestionMapper.ensureInitialized().hashValue(
      this as SurveyNumberQuestion,
    );
  }
}

extension SurveyNumberQuestionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SurveyNumberQuestion, $Out> {
  SurveyNumberQuestionCopyWith<$R, SurveyNumberQuestion, $Out>
  get $asSurveyNumberQuestion => $base.as(
    (v, t, t2) => _SurveyNumberQuestionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SurveyNumberQuestionCopyWith<
  $R,
  $In extends SurveyNumberQuestion,
  $Out
>
    implements SurveyQuestionCopyWith<$R, $In, $Out> {
  @override
  $R call({
    String? id,
    String? surveyId,
    int? position,
    String? key,
    String? title,
    String? description,
    bool? isRequired,
    num? minValue,
    num? maxValue,
    num? step,
  });
  SurveyNumberQuestionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SurveyNumberQuestionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SurveyNumberQuestion, $Out>
    implements SurveyNumberQuestionCopyWith<$R, SurveyNumberQuestion, $Out> {
  _SurveyNumberQuestionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SurveyNumberQuestion> $mapper =
      SurveyNumberQuestionMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? surveyId,
    int? position,
    String? key,
    String? title,
    Object? description = $none,
    bool? isRequired,
    Object? minValue = $none,
    Object? maxValue = $none,
    Object? step = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (surveyId != null) #surveyId: surveyId,
      if (position != null) #position: position,
      if (key != null) #key: key,
      if (title != null) #title: title,
      if (description != $none) #description: description,
      if (isRequired != null) #isRequired: isRequired,
      if (minValue != $none) #minValue: minValue,
      if (maxValue != $none) #maxValue: maxValue,
      if (step != $none) #step: step,
    }),
  );
  @override
  SurveyNumberQuestion $make(CopyWithData data) => SurveyNumberQuestion(
    id: data.get(#id, or: $value.id),
    surveyId: data.get(#surveyId, or: $value.surveyId),
    position: data.get(#position, or: $value.position),
    key: data.get(#key, or: $value.key),
    title: data.get(#title, or: $value.title),
    description: data.get(#description, or: $value.description),
    isRequired: data.get(#isRequired, or: $value.isRequired),
    minValue: data.get(#minValue, or: $value.minValue),
    maxValue: data.get(#maxValue, or: $value.maxValue),
    step: data.get(#step, or: $value.step),
  );

  @override
  SurveyNumberQuestionCopyWith<$R2, SurveyNumberQuestion, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SurveyNumberQuestionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
