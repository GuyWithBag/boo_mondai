// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'survey_likert_question.dto.dart';

class SurveyLikertQuestionMapper
    extends SubClassMapperBase<SurveyLikertQuestion> {
  SurveyLikertQuestionMapper._();

  static SurveyLikertQuestionMapper? _instance;
  static SurveyLikertQuestionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SurveyLikertQuestionMapper._());
      SurveyQuestionMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'SurveyLikertQuestion';

  static String _$id(SurveyLikertQuestion v) => v.id;
  static const Field<SurveyLikertQuestion, String> _f$id = Field('id', _$id);
  static String _$surveyId(SurveyLikertQuestion v) => v.surveyId;
  static const Field<SurveyLikertQuestion, String> _f$surveyId = Field(
    'surveyId',
    _$surveyId,
    key: r'survey_id',
  );
  static int _$position(SurveyLikertQuestion v) => v.position;
  static const Field<SurveyLikertQuestion, int> _f$position = Field(
    'position',
    _$position,
  );
  static String _$key(SurveyLikertQuestion v) => v.key;
  static const Field<SurveyLikertQuestion, String> _f$key = Field('key', _$key);
  static String _$title(SurveyLikertQuestion v) => v.title;
  static const Field<SurveyLikertQuestion, String> _f$title = Field(
    'title',
    _$title,
  );
  static String? _$description(SurveyLikertQuestion v) => v.description;
  static const Field<SurveyLikertQuestion, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
  );
  static bool _$isRequired(SurveyLikertQuestion v) => v.isRequired;
  static const Field<SurveyLikertQuestion, bool> _f$isRequired = Field(
    'isRequired',
    _$isRequired,
    key: r'is_required',
    opt: true,
    def: true,
  );
  static int _$minValue(SurveyLikertQuestion v) => v.minValue;
  static const Field<SurveyLikertQuestion, int> _f$minValue = Field(
    'minValue',
    _$minValue,
    key: r'min_value',
    opt: true,
    def: 1,
  );
  static int _$maxValue(SurveyLikertQuestion v) => v.maxValue;
  static const Field<SurveyLikertQuestion, int> _f$maxValue = Field(
    'maxValue',
    _$maxValue,
    key: r'max_value',
    opt: true,
    def: 5,
  );
  static String? _$minLabel(SurveyLikertQuestion v) => v.minLabel;
  static const Field<SurveyLikertQuestion, String> _f$minLabel = Field(
    'minLabel',
    _$minLabel,
    key: r'min_label',
    opt: true,
  );
  static String? _$maxLabel(SurveyLikertQuestion v) => v.maxLabel;
  static const Field<SurveyLikertQuestion, String> _f$maxLabel = Field(
    'maxLabel',
    _$maxLabel,
    key: r'max_label',
    opt: true,
  );

  @override
  final MappableFields<SurveyLikertQuestion> fields = const {
    #id: _f$id,
    #surveyId: _f$surveyId,
    #position: _f$position,
    #key: _f$key,
    #title: _f$title,
    #description: _f$description,
    #isRequired: _f$isRequired,
    #minValue: _f$minValue,
    #maxValue: _f$maxValue,
    #minLabel: _f$minLabel,
    #maxLabel: _f$maxLabel,
  };

  @override
  final String discriminatorKey = 'question_type';
  @override
  final dynamic discriminatorValue = 'likert';
  @override
  late final ClassMapperBase superMapper =
      SurveyQuestionMapper.ensureInitialized();

  static SurveyLikertQuestion _instantiate(DecodingData data) {
    return SurveyLikertQuestion(
      id: data.dec(_f$id),
      surveyId: data.dec(_f$surveyId),
      position: data.dec(_f$position),
      key: data.dec(_f$key),
      title: data.dec(_f$title),
      description: data.dec(_f$description),
      isRequired: data.dec(_f$isRequired),
      minValue: data.dec(_f$minValue),
      maxValue: data.dec(_f$maxValue),
      minLabel: data.dec(_f$minLabel),
      maxLabel: data.dec(_f$maxLabel),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SurveyLikertQuestion fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SurveyLikertQuestion>(map);
  }

  static SurveyLikertQuestion fromJson(String json) {
    return ensureInitialized().decodeJson<SurveyLikertQuestion>(json);
  }
}

mixin SurveyLikertQuestionMappable {
  String toJson() {
    return SurveyLikertQuestionMapper.ensureInitialized()
        .encodeJson<SurveyLikertQuestion>(this as SurveyLikertQuestion);
  }

  Map<String, dynamic> toMap() {
    return SurveyLikertQuestionMapper.ensureInitialized()
        .encodeMap<SurveyLikertQuestion>(this as SurveyLikertQuestion);
  }

  SurveyLikertQuestionCopyWith<
    SurveyLikertQuestion,
    SurveyLikertQuestion,
    SurveyLikertQuestion
  >
  get copyWith =>
      _SurveyLikertQuestionCopyWithImpl<
        SurveyLikertQuestion,
        SurveyLikertQuestion
      >(this as SurveyLikertQuestion, $identity, $identity);
  @override
  String toString() {
    return SurveyLikertQuestionMapper.ensureInitialized().stringifyValue(
      this as SurveyLikertQuestion,
    );
  }

  @override
  bool operator ==(Object other) {
    return SurveyLikertQuestionMapper.ensureInitialized().equalsValue(
      this as SurveyLikertQuestion,
      other,
    );
  }

  @override
  int get hashCode {
    return SurveyLikertQuestionMapper.ensureInitialized().hashValue(
      this as SurveyLikertQuestion,
    );
  }
}

extension SurveyLikertQuestionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SurveyLikertQuestion, $Out> {
  SurveyLikertQuestionCopyWith<$R, SurveyLikertQuestion, $Out>
  get $asSurveyLikertQuestion => $base.as(
    (v, t, t2) => _SurveyLikertQuestionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SurveyLikertQuestionCopyWith<
  $R,
  $In extends SurveyLikertQuestion,
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
    int? minValue,
    int? maxValue,
    String? minLabel,
    String? maxLabel,
  });
  SurveyLikertQuestionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SurveyLikertQuestionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SurveyLikertQuestion, $Out>
    implements SurveyLikertQuestionCopyWith<$R, SurveyLikertQuestion, $Out> {
  _SurveyLikertQuestionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SurveyLikertQuestion> $mapper =
      SurveyLikertQuestionMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? surveyId,
    int? position,
    String? key,
    String? title,
    Object? description = $none,
    bool? isRequired,
    int? minValue,
    int? maxValue,
    Object? minLabel = $none,
    Object? maxLabel = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (surveyId != null) #surveyId: surveyId,
      if (position != null) #position: position,
      if (key != null) #key: key,
      if (title != null) #title: title,
      if (description != $none) #description: description,
      if (isRequired != null) #isRequired: isRequired,
      if (minValue != null) #minValue: minValue,
      if (maxValue != null) #maxValue: maxValue,
      if (minLabel != $none) #minLabel: minLabel,
      if (maxLabel != $none) #maxLabel: maxLabel,
    }),
  );
  @override
  SurveyLikertQuestion $make(CopyWithData data) => SurveyLikertQuestion(
    id: data.get(#id, or: $value.id),
    surveyId: data.get(#surveyId, or: $value.surveyId),
    position: data.get(#position, or: $value.position),
    key: data.get(#key, or: $value.key),
    title: data.get(#title, or: $value.title),
    description: data.get(#description, or: $value.description),
    isRequired: data.get(#isRequired, or: $value.isRequired),
    minValue: data.get(#minValue, or: $value.minValue),
    maxValue: data.get(#maxValue, or: $value.maxValue),
    minLabel: data.get(#minLabel, or: $value.minLabel),
    maxLabel: data.get(#maxLabel, or: $value.maxLabel),
  );

  @override
  SurveyLikertQuestionCopyWith<$R2, SurveyLikertQuestion, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SurveyLikertQuestionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
