// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'survey_multiple_choice_input_block.dto.dart';

class SurveyMultipleChoiceInputBlockMapper
    extends SubClassMapperBase<SurveyMultipleChoiceInputBlock> {
  SurveyMultipleChoiceInputBlockMapper._();

  static SurveyMultipleChoiceInputBlockMapper? _instance;
  static SurveyMultipleChoiceInputBlockMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = SurveyMultipleChoiceInputBlockMapper._());
      SurveyBlockMapper.ensureInitialized().addSubMapper(_instance!);
      SurveyChoiceOptionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SurveyMultipleChoiceInputBlock';

  static String _$id(SurveyMultipleChoiceInputBlock v) => v.id;
  static const Field<SurveyMultipleChoiceInputBlock, String> _f$id =
      Field('id', _$id);
  static String _$surveyId(SurveyMultipleChoiceInputBlock v) => v.surveyId;
  static const Field<SurveyMultipleChoiceInputBlock, String> _f$surveyId =
      Field('surveyId', _$surveyId, key: r'survey_id');
  static String _$pageId(SurveyMultipleChoiceInputBlock v) => v.pageId;
  static const Field<SurveyMultipleChoiceInputBlock, String> _f$pageId =
      Field('pageId', _$pageId, key: r'page_id');
  static int _$position(SurveyMultipleChoiceInputBlock v) => v.position;
  static const Field<SurveyMultipleChoiceInputBlock, int> _f$position =
      Field('position', _$position);
  static String _$key(SurveyMultipleChoiceInputBlock v) => v.key;
  static const Field<SurveyMultipleChoiceInputBlock, String> _f$key =
      Field('key', _$key);
  static String _$prompt(SurveyMultipleChoiceInputBlock v) => v.prompt;
  static const Field<SurveyMultipleChoiceInputBlock, String> _f$prompt =
      Field('prompt', _$prompt);
  static String? _$description(SurveyMultipleChoiceInputBlock v) =>
      v.description;
  static const Field<SurveyMultipleChoiceInputBlock, String> _f$description =
      Field('description', _$description, opt: true);
  static bool _$isRequired(SurveyMultipleChoiceInputBlock v) => v.isRequired;
  static const Field<SurveyMultipleChoiceInputBlock, bool> _f$isRequired =
      Field('isRequired', _$isRequired,
          key: r'is_required', opt: true, def: true);
  static List<SurveyChoiceOption> _$options(SurveyMultipleChoiceInputBlock v) =>
      v.options;
  static const Field<SurveyMultipleChoiceInputBlock, List<SurveyChoiceOption>>
      _f$options = Field('options', _$options);
  static int _$minAnswers(SurveyMultipleChoiceInputBlock v) => v.minAnswers;
  static const Field<SurveyMultipleChoiceInputBlock, int> _f$minAnswers =
      Field('minAnswers', _$minAnswers, key: r'min_answers', opt: true, def: 1);
  static int _$maxAnswers(SurveyMultipleChoiceInputBlock v) => v.maxAnswers;
  static const Field<SurveyMultipleChoiceInputBlock, int> _f$maxAnswers =
      Field('maxAnswers', _$maxAnswers, key: r'max_answers', opt: true, def: 1);

  @override
  final MappableFields<SurveyMultipleChoiceInputBlock> fields = const {
    #id: _f$id,
    #surveyId: _f$surveyId,
    #pageId: _f$pageId,
    #position: _f$position,
    #key: _f$key,
    #prompt: _f$prompt,
    #description: _f$description,
    #isRequired: _f$isRequired,
    #options: _f$options,
    #minAnswers: _f$minAnswers,
    #maxAnswers: _f$maxAnswers,
  };

  @override
  final String discriminatorKey = 'block_type';
  @override
  final dynamic discriminatorValue = 'multiple_choice_input';
  @override
  late final ClassMapperBase superMapper =
      SurveyBlockMapper.ensureInitialized();

  static SurveyMultipleChoiceInputBlock _instantiate(DecodingData data) {
    return SurveyMultipleChoiceInputBlock(
        id: data.dec(_f$id),
        surveyId: data.dec(_f$surveyId),
        pageId: data.dec(_f$pageId),
        position: data.dec(_f$position),
        key: data.dec(_f$key),
        prompt: data.dec(_f$prompt),
        description: data.dec(_f$description),
        isRequired: data.dec(_f$isRequired),
        options: data.dec(_f$options),
        minAnswers: data.dec(_f$minAnswers),
        maxAnswers: data.dec(_f$maxAnswers));
  }

  @override
  final Function instantiate = _instantiate;

  static SurveyMultipleChoiceInputBlock fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SurveyMultipleChoiceInputBlock>(map);
  }

  static SurveyMultipleChoiceInputBlock fromJson(String json) {
    return ensureInitialized().decodeJson<SurveyMultipleChoiceInputBlock>(json);
  }
}

mixin SurveyMultipleChoiceInputBlockMappable {
  String toJson() {
    return SurveyMultipleChoiceInputBlockMapper.ensureInitialized()
        .encodeJson<SurveyMultipleChoiceInputBlock>(
            this as SurveyMultipleChoiceInputBlock);
  }

  Map<String, dynamic> toMap() {
    return SurveyMultipleChoiceInputBlockMapper.ensureInitialized()
        .encodeMap<SurveyMultipleChoiceInputBlock>(
            this as SurveyMultipleChoiceInputBlock);
  }

  SurveyMultipleChoiceInputBlockCopyWith<SurveyMultipleChoiceInputBlock,
          SurveyMultipleChoiceInputBlock, SurveyMultipleChoiceInputBlock>
      get copyWith => _SurveyMultipleChoiceInputBlockCopyWithImpl<
              SurveyMultipleChoiceInputBlock, SurveyMultipleChoiceInputBlock>(
          this as SurveyMultipleChoiceInputBlock, $identity, $identity);
  @override
  String toString() {
    return SurveyMultipleChoiceInputBlockMapper.ensureInitialized()
        .stringifyValue(this as SurveyMultipleChoiceInputBlock);
  }

  @override
  bool operator ==(Object other) {
    return SurveyMultipleChoiceInputBlockMapper.ensureInitialized()
        .equalsValue(this as SurveyMultipleChoiceInputBlock, other);
  }

  @override
  int get hashCode {
    return SurveyMultipleChoiceInputBlockMapper.ensureInitialized()
        .hashValue(this as SurveyMultipleChoiceInputBlock);
  }
}

extension SurveyMultipleChoiceInputBlockValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SurveyMultipleChoiceInputBlock, $Out> {
  SurveyMultipleChoiceInputBlockCopyWith<$R, SurveyMultipleChoiceInputBlock,
          $Out>
      get $asSurveyMultipleChoiceInputBlock => $base.as((v, t, t2) =>
          _SurveyMultipleChoiceInputBlockCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SurveyMultipleChoiceInputBlockCopyWith<
    $R,
    $In extends SurveyMultipleChoiceInputBlock,
    $Out> implements SurveyBlockCopyWith<$R, $In, $Out> {
  ListCopyWith<
      $R,
      SurveyChoiceOption,
      SurveyChoiceOptionCopyWith<$R, SurveyChoiceOption,
          SurveyChoiceOption>> get options;
  @override
  $R call(
      {String? id,
      String? surveyId,
      String? pageId,
      int? position,
      String? key,
      String? prompt,
      String? description,
      bool? isRequired,
      List<SurveyChoiceOption>? options,
      int? minAnswers,
      int? maxAnswers});
  SurveyMultipleChoiceInputBlockCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _SurveyMultipleChoiceInputBlockCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SurveyMultipleChoiceInputBlock, $Out>
    implements
        SurveyMultipleChoiceInputBlockCopyWith<$R,
            SurveyMultipleChoiceInputBlock, $Out> {
  _SurveyMultipleChoiceInputBlockCopyWithImpl(
      super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SurveyMultipleChoiceInputBlock> $mapper =
      SurveyMultipleChoiceInputBlockMapper.ensureInitialized();
  @override
  ListCopyWith<
      $R,
      SurveyChoiceOption,
      SurveyChoiceOptionCopyWith<$R, SurveyChoiceOption,
          SurveyChoiceOption>> get options => ListCopyWith(
      $value.options, (v, t) => v.copyWith.$chain(t), (v) => call(options: v));
  @override
  $R call(
          {String? id,
          String? surveyId,
          String? pageId,
          int? position,
          String? key,
          String? prompt,
          Object? description = $none,
          bool? isRequired,
          List<SurveyChoiceOption>? options,
          int? minAnswers,
          int? maxAnswers}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (surveyId != null) #surveyId: surveyId,
        if (pageId != null) #pageId: pageId,
        if (position != null) #position: position,
        if (key != null) #key: key,
        if (prompt != null) #prompt: prompt,
        if (description != $none) #description: description,
        if (isRequired != null) #isRequired: isRequired,
        if (options != null) #options: options,
        if (minAnswers != null) #minAnswers: minAnswers,
        if (maxAnswers != null) #maxAnswers: maxAnswers
      }));
  @override
  SurveyMultipleChoiceInputBlock $make(CopyWithData data) =>
      SurveyMultipleChoiceInputBlock(
          id: data.get(#id, or: $value.id),
          surveyId: data.get(#surveyId, or: $value.surveyId),
          pageId: data.get(#pageId, or: $value.pageId),
          position: data.get(#position, or: $value.position),
          key: data.get(#key, or: $value.key),
          prompt: data.get(#prompt, or: $value.prompt),
          description: data.get(#description, or: $value.description),
          isRequired: data.get(#isRequired, or: $value.isRequired),
          options: data.get(#options, or: $value.options),
          minAnswers: data.get(#minAnswers, or: $value.minAnswers),
          maxAnswers: data.get(#maxAnswers, or: $value.maxAnswers));

  @override
  SurveyMultipleChoiceInputBlockCopyWith<$R2, SurveyMultipleChoiceInputBlock,
      $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _SurveyMultipleChoiceInputBlockCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
