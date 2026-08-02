// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'survey_text_question.dto.dart';

class SurveyTextQuestionMapper extends SubClassMapperBase<SurveyTextQuestion> {
  SurveyTextQuestionMapper._();

  static SurveyTextQuestionMapper? _instance;
  static SurveyTextQuestionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SurveyTextQuestionMapper._());
      SurveyQuestionMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'SurveyTextQuestion';

  static String _$id(SurveyTextQuestion v) => v.id;
  static const Field<SurveyTextQuestion, String> _f$id = Field('id', _$id);
  static String _$surveyId(SurveyTextQuestion v) => v.surveyId;
  static const Field<SurveyTextQuestion, String> _f$surveyId = Field(
    'surveyId',
    _$surveyId,
    key: r'survey_id',
  );
  static int _$position(SurveyTextQuestion v) => v.position;
  static const Field<SurveyTextQuestion, int> _f$position = Field(
    'position',
    _$position,
  );
  static String _$key(SurveyTextQuestion v) => v.key;
  static const Field<SurveyTextQuestion, String> _f$key = Field('key', _$key);
  static String _$title(SurveyTextQuestion v) => v.title;
  static const Field<SurveyTextQuestion, String> _f$title = Field(
    'title',
    _$title,
  );
  static String? _$description(SurveyTextQuestion v) => v.description;
  static const Field<SurveyTextQuestion, String> _f$description = Field(
    'description',
    _$description,
    opt: true,
  );
  static bool _$isRequired(SurveyTextQuestion v) => v.isRequired;
  static const Field<SurveyTextQuestion, bool> _f$isRequired = Field(
    'isRequired',
    _$isRequired,
    key: r'is_required',
    opt: true,
    def: true,
  );
  static bool _$isLongText(SurveyTextQuestion v) => v.isLongText;
  static const Field<SurveyTextQuestion, bool> _f$isLongText = Field(
    'isLongText',
    _$isLongText,
    key: r'is_long_text',
    opt: true,
    def: false,
  );
  static String? _$placeholder(SurveyTextQuestion v) => v.placeholder;
  static const Field<SurveyTextQuestion, String> _f$placeholder = Field(
    'placeholder',
    _$placeholder,
    opt: true,
  );
  static int? _$minLength(SurveyTextQuestion v) => v.minLength;
  static const Field<SurveyTextQuestion, int> _f$minLength = Field(
    'minLength',
    _$minLength,
    key: r'min_length',
    opt: true,
  );
  static int? _$maxLength(SurveyTextQuestion v) => v.maxLength;
  static const Field<SurveyTextQuestion, int> _f$maxLength = Field(
    'maxLength',
    _$maxLength,
    key: r'max_length',
    opt: true,
  );

  @override
  final MappableFields<SurveyTextQuestion> fields = const {
    #id: _f$id,
    #surveyId: _f$surveyId,
    #position: _f$position,
    #key: _f$key,
    #title: _f$title,
    #description: _f$description,
    #isRequired: _f$isRequired,
    #isLongText: _f$isLongText,
    #placeholder: _f$placeholder,
    #minLength: _f$minLength,
    #maxLength: _f$maxLength,
  };

  @override
  final String discriminatorKey = 'question_type';
  @override
  final dynamic discriminatorValue = 'text';
  @override
  late final ClassMapperBase superMapper =
      SurveyQuestionMapper.ensureInitialized();

  static SurveyTextQuestion _instantiate(DecodingData data) {
    return SurveyTextQuestion(
      id: data.dec(_f$id),
      surveyId: data.dec(_f$surveyId),
      position: data.dec(_f$position),
      key: data.dec(_f$key),
      title: data.dec(_f$title),
      description: data.dec(_f$description),
      isRequired: data.dec(_f$isRequired),
      isLongText: data.dec(_f$isLongText),
      placeholder: data.dec(_f$placeholder),
      minLength: data.dec(_f$minLength),
      maxLength: data.dec(_f$maxLength),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SurveyTextQuestion fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SurveyTextQuestion>(map);
  }

  static SurveyTextQuestion fromJson(String json) {
    return ensureInitialized().decodeJson<SurveyTextQuestion>(json);
  }
}

mixin SurveyTextQuestionMappable {
  String toJson() {
    return SurveyTextQuestionMapper.ensureInitialized()
        .encodeJson<SurveyTextQuestion>(this as SurveyTextQuestion);
  }

  Map<String, dynamic> toMap() {
    return SurveyTextQuestionMapper.ensureInitialized()
        .encodeMap<SurveyTextQuestion>(this as SurveyTextQuestion);
  }

  SurveyTextQuestionCopyWith<
    SurveyTextQuestion,
    SurveyTextQuestion,
    SurveyTextQuestion
  >
  get copyWith =>
      _SurveyTextQuestionCopyWithImpl<SurveyTextQuestion, SurveyTextQuestion>(
        this as SurveyTextQuestion,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SurveyTextQuestionMapper.ensureInitialized().stringifyValue(
      this as SurveyTextQuestion,
    );
  }

  @override
  bool operator ==(Object other) {
    return SurveyTextQuestionMapper.ensureInitialized().equalsValue(
      this as SurveyTextQuestion,
      other,
    );
  }

  @override
  int get hashCode {
    return SurveyTextQuestionMapper.ensureInitialized().hashValue(
      this as SurveyTextQuestion,
    );
  }
}

extension SurveyTextQuestionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SurveyTextQuestion, $Out> {
  SurveyTextQuestionCopyWith<$R, SurveyTextQuestion, $Out>
  get $asSurveyTextQuestion => $base.as(
    (v, t, t2) => _SurveyTextQuestionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SurveyTextQuestionCopyWith<
  $R,
  $In extends SurveyTextQuestion,
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
    bool? isLongText,
    String? placeholder,
    int? minLength,
    int? maxLength,
  });
  SurveyTextQuestionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SurveyTextQuestionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SurveyTextQuestion, $Out>
    implements SurveyTextQuestionCopyWith<$R, SurveyTextQuestion, $Out> {
  _SurveyTextQuestionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SurveyTextQuestion> $mapper =
      SurveyTextQuestionMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? surveyId,
    int? position,
    String? key,
    String? title,
    Object? description = $none,
    bool? isRequired,
    bool? isLongText,
    Object? placeholder = $none,
    Object? minLength = $none,
    Object? maxLength = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (surveyId != null) #surveyId: surveyId,
      if (position != null) #position: position,
      if (key != null) #key: key,
      if (title != null) #title: title,
      if (description != $none) #description: description,
      if (isRequired != null) #isRequired: isRequired,
      if (isLongText != null) #isLongText: isLongText,
      if (placeholder != $none) #placeholder: placeholder,
      if (minLength != $none) #minLength: minLength,
      if (maxLength != $none) #maxLength: maxLength,
    }),
  );
  @override
  SurveyTextQuestion $make(CopyWithData data) => SurveyTextQuestion(
    id: data.get(#id, or: $value.id),
    surveyId: data.get(#surveyId, or: $value.surveyId),
    position: data.get(#position, or: $value.position),
    key: data.get(#key, or: $value.key),
    title: data.get(#title, or: $value.title),
    description: data.get(#description, or: $value.description),
    isRequired: data.get(#isRequired, or: $value.isRequired),
    isLongText: data.get(#isLongText, or: $value.isLongText),
    placeholder: data.get(#placeholder, or: $value.placeholder),
    minLength: data.get(#minLength, or: $value.minLength),
    maxLength: data.get(#maxLength, or: $value.maxLength),
  );

  @override
  SurveyTextQuestionCopyWith<$R2, SurveyTextQuestion, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SurveyTextQuestionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
