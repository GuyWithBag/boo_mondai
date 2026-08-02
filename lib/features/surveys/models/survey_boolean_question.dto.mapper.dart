// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'survey_boolean_question.dto.dart';

class SurveyBooleanQuestionMapper
    extends SubClassMapperBase<SurveyBooleanQuestion> {
  SurveyBooleanQuestionMapper._();

  static SurveyBooleanQuestionMapper? _instance;
  static SurveyBooleanQuestionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SurveyBooleanQuestionMapper._());
      SurveyQuestionMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'SurveyBooleanQuestion';

  static String _$id(SurveyBooleanQuestion v) => v.id;
  static const Field<SurveyBooleanQuestion, String> _f$id = Field('id', _$id);
  static String _$surveyId(SurveyBooleanQuestion v) => v.surveyId;
  static const Field<SurveyBooleanQuestion, String> _f$surveyId = Field(
    'surveyId',
    _$surveyId,
    key: r'survey_id',
  );
  static int _$position(SurveyBooleanQuestion v) => v.position;
  static const Field<SurveyBooleanQuestion, int> _f$position = Field(
    'position',
    _$position,
  );
  static String _$key(SurveyBooleanQuestion v) => v.key;
  static const Field<SurveyBooleanQuestion, String> _f$key = Field(
    'key',
    _$key,
  );
  static String _$title(SurveyBooleanQuestion v) => v.title;
  static const Field<SurveyBooleanQuestion, String> _f$title = Field(
    'title',
    _$title,
  );
  static String? _$description(SurveyBooleanQuestion v) => v.description;
  static const Field<SurveyBooleanQuestion, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
  );
  static bool _$isRequired(SurveyBooleanQuestion v) => v.isRequired;
  static const Field<SurveyBooleanQuestion, bool> _f$isRequired = Field(
    'isRequired',
    _$isRequired,
    key: r'is_required',
    opt: true,
    def: true,
  );
  static String _$trueLabel(SurveyBooleanQuestion v) => v.trueLabel;
  static const Field<SurveyBooleanQuestion, String> _f$trueLabel = Field(
    'trueLabel',
    _$trueLabel,
    key: r'true_label',
    opt: true,
    def: 'Yes',
  );
  static String _$falseLabel(SurveyBooleanQuestion v) => v.falseLabel;
  static const Field<SurveyBooleanQuestion, String> _f$falseLabel = Field(
    'falseLabel',
    _$falseLabel,
    key: r'false_label',
    opt: true,
    def: 'No',
  );

  @override
  final MappableFields<SurveyBooleanQuestion> fields = const {
    #id: _f$id,
    #surveyId: _f$surveyId,
    #position: _f$position,
    #key: _f$key,
    #title: _f$title,
    #description: _f$description,
    #isRequired: _f$isRequired,
    #trueLabel: _f$trueLabel,
    #falseLabel: _f$falseLabel,
  };

  @override
  final String discriminatorKey = 'question_type';
  @override
  final dynamic discriminatorValue = 'boolean';
  @override
  late final ClassMapperBase superMapper =
      SurveyQuestionMapper.ensureInitialized();

  static SurveyBooleanQuestion _instantiate(DecodingData data) {
    return SurveyBooleanQuestion(
      id: data.dec(_f$id),
      surveyId: data.dec(_f$surveyId),
      position: data.dec(_f$position),
      key: data.dec(_f$key),
      title: data.dec(_f$title),
      description: data.dec(_f$description),
      isRequired: data.dec(_f$isRequired),
      trueLabel: data.dec(_f$trueLabel),
      falseLabel: data.dec(_f$falseLabel),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SurveyBooleanQuestion fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SurveyBooleanQuestion>(map);
  }

  static SurveyBooleanQuestion fromJson(String json) {
    return ensureInitialized().decodeJson<SurveyBooleanQuestion>(json);
  }
}

mixin SurveyBooleanQuestionMappable {
  String toJson() {
    return SurveyBooleanQuestionMapper.ensureInitialized()
        .encodeJson<SurveyBooleanQuestion>(this as SurveyBooleanQuestion);
  }

  Map<String, dynamic> toMap() {
    return SurveyBooleanQuestionMapper.ensureInitialized()
        .encodeMap<SurveyBooleanQuestion>(this as SurveyBooleanQuestion);
  }

  SurveyBooleanQuestionCopyWith<
    SurveyBooleanQuestion,
    SurveyBooleanQuestion,
    SurveyBooleanQuestion
  >
  get copyWith =>
      _SurveyBooleanQuestionCopyWithImpl<
        SurveyBooleanQuestion,
        SurveyBooleanQuestion
      >(this as SurveyBooleanQuestion, $identity, $identity);
  @override
  String toString() {
    return SurveyBooleanQuestionMapper.ensureInitialized().stringifyValue(
      this as SurveyBooleanQuestion,
    );
  }

  @override
  bool operator ==(Object other) {
    return SurveyBooleanQuestionMapper.ensureInitialized().equalsValue(
      this as SurveyBooleanQuestion,
      other,
    );
  }

  @override
  int get hashCode {
    return SurveyBooleanQuestionMapper.ensureInitialized().hashValue(
      this as SurveyBooleanQuestion,
    );
  }
}

extension SurveyBooleanQuestionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SurveyBooleanQuestion, $Out> {
  SurveyBooleanQuestionCopyWith<$R, SurveyBooleanQuestion, $Out>
  get $asSurveyBooleanQuestion => $base.as(
    (v, t, t2) => _SurveyBooleanQuestionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SurveyBooleanQuestionCopyWith<
  $R,
  $In extends SurveyBooleanQuestion,
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
    String? trueLabel,
    String? falseLabel,
  });
  SurveyBooleanQuestionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SurveyBooleanQuestionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SurveyBooleanQuestion, $Out>
    implements SurveyBooleanQuestionCopyWith<$R, SurveyBooleanQuestion, $Out> {
  _SurveyBooleanQuestionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SurveyBooleanQuestion> $mapper =
      SurveyBooleanQuestionMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? surveyId,
    int? position,
    String? key,
    String? title,
    Object? description = $none,
    bool? isRequired,
    String? trueLabel,
    String? falseLabel,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (surveyId != null) #surveyId: surveyId,
      if (position != null) #position: position,
      if (key != null) #key: key,
      if (title != null) #title: title,
      if (description != $none) #description: description,
      if (isRequired != null) #isRequired: isRequired,
      if (trueLabel != null) #trueLabel: trueLabel,
      if (falseLabel != null) #falseLabel: falseLabel,
    }),
  );
  @override
  SurveyBooleanQuestion $make(CopyWithData data) => SurveyBooleanQuestion(
    id: data.get(#id, or: $value.id),
    surveyId: data.get(#surveyId, or: $value.surveyId),
    position: data.get(#position, or: $value.position),
    key: data.get(#key, or: $value.key),
    title: data.get(#title, or: $value.title),
    description: data.get(#description, or: $value.description),
    isRequired: data.get(#isRequired, or: $value.isRequired),
    trueLabel: data.get(#trueLabel, or: $value.trueLabel),
    falseLabel: data.get(#falseLabel, or: $value.falseLabel),
  );

  @override
  SurveyBooleanQuestionCopyWith<$R2, SurveyBooleanQuestion, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SurveyBooleanQuestionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
