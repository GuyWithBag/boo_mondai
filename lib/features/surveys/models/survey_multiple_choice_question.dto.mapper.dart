// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'survey_multiple_choice_question.dto.dart';

class SurveyMultipleChoiceQuestionMapper
    extends SubClassMapperBase<SurveyMultipleChoiceQuestion> {
  SurveyMultipleChoiceQuestionMapper._();

  static SurveyMultipleChoiceQuestionMapper? _instance;
  static SurveyMultipleChoiceQuestionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = SurveyMultipleChoiceQuestionMapper._(),
      );
      SurveyQuestionMapper.ensureInitialized().addSubMapper(_instance!);
      SurveyChoiceOptionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SurveyMultipleChoiceQuestion';

  static String _$id(SurveyMultipleChoiceQuestion v) => v.id;
  static const Field<SurveyMultipleChoiceQuestion, String> _f$id = Field(
    'id',
    _$id,
  );
  static String _$surveyId(SurveyMultipleChoiceQuestion v) => v.surveyId;
  static const Field<SurveyMultipleChoiceQuestion, String> _f$surveyId = Field(
    'surveyId',
    _$surveyId,
    key: r'survey_id',
  );
  static int _$position(SurveyMultipleChoiceQuestion v) => v.position;
  static const Field<SurveyMultipleChoiceQuestion, int> _f$position = Field(
    'position',
    _$position,
  );
  static String _$key(SurveyMultipleChoiceQuestion v) => v.key;
  static const Field<SurveyMultipleChoiceQuestion, String> _f$key = Field(
    'key',
    _$key,
  );
  static String _$title(SurveyMultipleChoiceQuestion v) => v.title;
  static const Field<SurveyMultipleChoiceQuestion, String> _f$title = Field(
    'title',
    _$title,
  );
  static String? _$description(SurveyMultipleChoiceQuestion v) => v.description;
  static const Field<SurveyMultipleChoiceQuestion, String> _f$description =
      Field('description', _$description, opt: true);
  static bool _$isRequired(SurveyMultipleChoiceQuestion v) => v.isRequired;
  static const Field<SurveyMultipleChoiceQuestion, bool> _f$isRequired = Field(
    'isRequired',
    _$isRequired,
    key: r'is_required',
    opt: true,
    def: true,
  );
  static List<SurveyChoiceOption> _$options(SurveyMultipleChoiceQuestion v) =>
      v.options;
  static const Field<SurveyMultipleChoiceQuestion, List<SurveyChoiceOption>>
  _f$options = Field('options', _$options);
  static int _$minAnswers(SurveyMultipleChoiceQuestion v) => v.minAnswers;
  static const Field<SurveyMultipleChoiceQuestion, int> _f$minAnswers = Field(
    'minAnswers',
    _$minAnswers,
    key: r'min_answers',
    opt: true,
    def: 1,
  );
  static int _$maxAnswers(SurveyMultipleChoiceQuestion v) => v.maxAnswers;
  static const Field<SurveyMultipleChoiceQuestion, int> _f$maxAnswers = Field(
    'maxAnswers',
    _$maxAnswers,
    key: r'max_answers',
    opt: true,
    def: 1,
  );

  @override
  final MappableFields<SurveyMultipleChoiceQuestion> fields = const {
    #id: _f$id,
    #surveyId: _f$surveyId,
    #position: _f$position,
    #key: _f$key,
    #title: _f$title,
    #description: _f$description,
    #isRequired: _f$isRequired,
    #options: _f$options,
    #minAnswers: _f$minAnswers,
    #maxAnswers: _f$maxAnswers,
  };

  @override
  final String discriminatorKey = 'question_type';
  @override
  final dynamic discriminatorValue = 'multiple_choice';
  @override
  late final ClassMapperBase superMapper =
      SurveyQuestionMapper.ensureInitialized();

  static SurveyMultipleChoiceQuestion _instantiate(DecodingData data) {
    return SurveyMultipleChoiceQuestion(
      id: data.dec(_f$id),
      surveyId: data.dec(_f$surveyId),
      position: data.dec(_f$position),
      key: data.dec(_f$key),
      title: data.dec(_f$title),
      description: data.dec(_f$description),
      isRequired: data.dec(_f$isRequired),
      options: data.dec(_f$options),
      minAnswers: data.dec(_f$minAnswers),
      maxAnswers: data.dec(_f$maxAnswers),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SurveyMultipleChoiceQuestion fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SurveyMultipleChoiceQuestion>(map);
  }

  static SurveyMultipleChoiceQuestion fromJson(String json) {
    return ensureInitialized().decodeJson<SurveyMultipleChoiceQuestion>(json);
  }
}

mixin SurveyMultipleChoiceQuestionMappable {
  String toJson() {
    return SurveyMultipleChoiceQuestionMapper.ensureInitialized()
        .encodeJson<SurveyMultipleChoiceQuestion>(
          this as SurveyMultipleChoiceQuestion,
        );
  }

  Map<String, dynamic> toMap() {
    return SurveyMultipleChoiceQuestionMapper.ensureInitialized()
        .encodeMap<SurveyMultipleChoiceQuestion>(
          this as SurveyMultipleChoiceQuestion,
        );
  }

  SurveyMultipleChoiceQuestionCopyWith<
    SurveyMultipleChoiceQuestion,
    SurveyMultipleChoiceQuestion,
    SurveyMultipleChoiceQuestion
  >
  get copyWith =>
      _SurveyMultipleChoiceQuestionCopyWithImpl<
        SurveyMultipleChoiceQuestion,
        SurveyMultipleChoiceQuestion
      >(this as SurveyMultipleChoiceQuestion, $identity, $identity);
  @override
  String toString() {
    return SurveyMultipleChoiceQuestionMapper.ensureInitialized()
        .stringifyValue(this as SurveyMultipleChoiceQuestion);
  }

  @override
  bool operator ==(Object other) {
    return SurveyMultipleChoiceQuestionMapper.ensureInitialized().equalsValue(
      this as SurveyMultipleChoiceQuestion,
      other,
    );
  }

  @override
  int get hashCode {
    return SurveyMultipleChoiceQuestionMapper.ensureInitialized().hashValue(
      this as SurveyMultipleChoiceQuestion,
    );
  }
}

extension SurveyMultipleChoiceQuestionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SurveyMultipleChoiceQuestion, $Out> {
  SurveyMultipleChoiceQuestionCopyWith<$R, SurveyMultipleChoiceQuestion, $Out>
  get $asSurveyMultipleChoiceQuestion => $base.as(
    (v, t, t2) => _SurveyMultipleChoiceQuestionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SurveyMultipleChoiceQuestionCopyWith<
  $R,
  $In extends SurveyMultipleChoiceQuestion,
  $Out
>
    implements SurveyQuestionCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    SurveyChoiceOption,
    SurveyChoiceOptionCopyWith<$R, SurveyChoiceOption, SurveyChoiceOption>
  >
  get options;
  @override
  $R call({
    String? id,
    String? surveyId,
    int? position,
    String? key,
    String? title,
    String? description,
    bool? isRequired,
    List<SurveyChoiceOption>? options,
    int? minAnswers,
    int? maxAnswers,
  });
  SurveyMultipleChoiceQuestionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SurveyMultipleChoiceQuestionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SurveyMultipleChoiceQuestion, $Out>
    implements
        SurveyMultipleChoiceQuestionCopyWith<
          $R,
          SurveyMultipleChoiceQuestion,
          $Out
        > {
  _SurveyMultipleChoiceQuestionCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<SurveyMultipleChoiceQuestion> $mapper =
      SurveyMultipleChoiceQuestionMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    SurveyChoiceOption,
    SurveyChoiceOptionCopyWith<$R, SurveyChoiceOption, SurveyChoiceOption>
  >
  get options => ListCopyWith(
    $value.options,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(options: v),
  );
  @override
  $R call({
    String? id,
    String? surveyId,
    int? position,
    String? key,
    String? title,
    Object? description = $none,
    bool? isRequired,
    List<SurveyChoiceOption>? options,
    int? minAnswers,
    int? maxAnswers,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (surveyId != null) #surveyId: surveyId,
      if (position != null) #position: position,
      if (key != null) #key: key,
      if (title != null) #title: title,
      if (description != $none) #description: description,
      if (isRequired != null) #isRequired: isRequired,
      if (options != null) #options: options,
      if (minAnswers != null) #minAnswers: minAnswers,
      if (maxAnswers != null) #maxAnswers: maxAnswers,
    }),
  );
  @override
  SurveyMultipleChoiceQuestion $make(CopyWithData data) =>
      SurveyMultipleChoiceQuestion(
        id: data.get(#id, or: $value.id),
        surveyId: data.get(#surveyId, or: $value.surveyId),
        position: data.get(#position, or: $value.position),
        key: data.get(#key, or: $value.key),
        title: data.get(#title, or: $value.title),
        description: data.get(#description, or: $value.description),
        isRequired: data.get(#isRequired, or: $value.isRequired),
        options: data.get(#options, or: $value.options),
        minAnswers: data.get(#minAnswers, or: $value.minAnswers),
        maxAnswers: data.get(#maxAnswers, or: $value.maxAnswers),
      );

  @override
  SurveyMultipleChoiceQuestionCopyWith<$R2, SurveyMultipleChoiceQuestion, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SurveyMultipleChoiceQuestionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
