// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'survey_number_input_block.dto.dart';

class SurveyNumberInputBlockMapper
    extends SubClassMapperBase<SurveyNumberInputBlock> {
  SurveyNumberInputBlockMapper._();

  static SurveyNumberInputBlockMapper? _instance;
  static SurveyNumberInputBlockMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SurveyNumberInputBlockMapper._());
      SurveyBlockMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'SurveyNumberInputBlock';

  static String _$id(SurveyNumberInputBlock v) => v.id;
  static const Field<SurveyNumberInputBlock, String> _f$id = Field('id', _$id);
  static String _$surveyId(SurveyNumberInputBlock v) => v.surveyId;
  static const Field<SurveyNumberInputBlock, String> _f$surveyId =
      Field('surveyId', _$surveyId, key: r'survey_id');
  static String _$pageId(SurveyNumberInputBlock v) => v.pageId;
  static const Field<SurveyNumberInputBlock, String> _f$pageId =
      Field('pageId', _$pageId, key: r'page_id');
  static int _$position(SurveyNumberInputBlock v) => v.position;
  static const Field<SurveyNumberInputBlock, int> _f$position =
      Field('position', _$position);
  static String _$key(SurveyNumberInputBlock v) => v.key;
  static const Field<SurveyNumberInputBlock, String> _f$key =
      Field('key', _$key);
  static String _$prompt(SurveyNumberInputBlock v) => v.prompt;
  static const Field<SurveyNumberInputBlock, String> _f$prompt =
      Field('prompt', _$prompt);
  static String? _$description(SurveyNumberInputBlock v) => v.description;
  static const Field<SurveyNumberInputBlock, String> _f$description =
      Field('description', _$description, opt: true);
  static bool _$isRequired(SurveyNumberInputBlock v) => v.isRequired;
  static const Field<SurveyNumberInputBlock, bool> _f$isRequired = Field(
      'isRequired', _$isRequired,
      key: r'is_required', opt: true, def: true);
  static num? _$minValue(SurveyNumberInputBlock v) => v.minValue;
  static const Field<SurveyNumberInputBlock, num> _f$minValue =
      Field('minValue', _$minValue, key: r'min_value', opt: true);
  static num? _$maxValue(SurveyNumberInputBlock v) => v.maxValue;
  static const Field<SurveyNumberInputBlock, num> _f$maxValue =
      Field('maxValue', _$maxValue, key: r'max_value', opt: true);
  static num? _$step(SurveyNumberInputBlock v) => v.step;
  static const Field<SurveyNumberInputBlock, num> _f$step =
      Field('step', _$step, opt: true);

  @override
  final MappableFields<SurveyNumberInputBlock> fields = const {
    #id: _f$id,
    #surveyId: _f$surveyId,
    #pageId: _f$pageId,
    #position: _f$position,
    #key: _f$key,
    #prompt: _f$prompt,
    #description: _f$description,
    #isRequired: _f$isRequired,
    #minValue: _f$minValue,
    #maxValue: _f$maxValue,
    #step: _f$step,
  };

  @override
  final String discriminatorKey = 'block_type';
  @override
  final dynamic discriminatorValue = 'number_input';
  @override
  late final ClassMapperBase superMapper =
      SurveyBlockMapper.ensureInitialized();

  static SurveyNumberInputBlock _instantiate(DecodingData data) {
    return SurveyNumberInputBlock(
        id: data.dec(_f$id),
        surveyId: data.dec(_f$surveyId),
        pageId: data.dec(_f$pageId),
        position: data.dec(_f$position),
        key: data.dec(_f$key),
        prompt: data.dec(_f$prompt),
        description: data.dec(_f$description),
        isRequired: data.dec(_f$isRequired),
        minValue: data.dec(_f$minValue),
        maxValue: data.dec(_f$maxValue),
        step: data.dec(_f$step));
  }

  @override
  final Function instantiate = _instantiate;

  static SurveyNumberInputBlock fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SurveyNumberInputBlock>(map);
  }

  static SurveyNumberInputBlock fromJson(String json) {
    return ensureInitialized().decodeJson<SurveyNumberInputBlock>(json);
  }
}

mixin SurveyNumberInputBlockMappable {
  String toJson() {
    return SurveyNumberInputBlockMapper.ensureInitialized()
        .encodeJson<SurveyNumberInputBlock>(this as SurveyNumberInputBlock);
  }

  Map<String, dynamic> toMap() {
    return SurveyNumberInputBlockMapper.ensureInitialized()
        .encodeMap<SurveyNumberInputBlock>(this as SurveyNumberInputBlock);
  }

  SurveyNumberInputBlockCopyWith<SurveyNumberInputBlock, SurveyNumberInputBlock,
          SurveyNumberInputBlock>
      get copyWith => _SurveyNumberInputBlockCopyWithImpl<
              SurveyNumberInputBlock, SurveyNumberInputBlock>(
          this as SurveyNumberInputBlock, $identity, $identity);
  @override
  String toString() {
    return SurveyNumberInputBlockMapper.ensureInitialized()
        .stringifyValue(this as SurveyNumberInputBlock);
  }

  @override
  bool operator ==(Object other) {
    return SurveyNumberInputBlockMapper.ensureInitialized()
        .equalsValue(this as SurveyNumberInputBlock, other);
  }

  @override
  int get hashCode {
    return SurveyNumberInputBlockMapper.ensureInitialized()
        .hashValue(this as SurveyNumberInputBlock);
  }
}

extension SurveyNumberInputBlockValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SurveyNumberInputBlock, $Out> {
  SurveyNumberInputBlockCopyWith<$R, SurveyNumberInputBlock, $Out>
      get $asSurveyNumberInputBlock => $base.as((v, t, t2) =>
          _SurveyNumberInputBlockCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SurveyNumberInputBlockCopyWith<
    $R,
    $In extends SurveyNumberInputBlock,
    $Out> implements SurveyBlockCopyWith<$R, $In, $Out> {
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
      num? minValue,
      num? maxValue,
      num? step});
  SurveyNumberInputBlockCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _SurveyNumberInputBlockCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SurveyNumberInputBlock, $Out>
    implements
        SurveyNumberInputBlockCopyWith<$R, SurveyNumberInputBlock, $Out> {
  _SurveyNumberInputBlockCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SurveyNumberInputBlock> $mapper =
      SurveyNumberInputBlockMapper.ensureInitialized();
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
          Object? minValue = $none,
          Object? maxValue = $none,
          Object? step = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (surveyId != null) #surveyId: surveyId,
        if (pageId != null) #pageId: pageId,
        if (position != null) #position: position,
        if (key != null) #key: key,
        if (prompt != null) #prompt: prompt,
        if (description != $none) #description: description,
        if (isRequired != null) #isRequired: isRequired,
        if (minValue != $none) #minValue: minValue,
        if (maxValue != $none) #maxValue: maxValue,
        if (step != $none) #step: step
      }));
  @override
  SurveyNumberInputBlock $make(CopyWithData data) => SurveyNumberInputBlock(
      id: data.get(#id, or: $value.id),
      surveyId: data.get(#surveyId, or: $value.surveyId),
      pageId: data.get(#pageId, or: $value.pageId),
      position: data.get(#position, or: $value.position),
      key: data.get(#key, or: $value.key),
      prompt: data.get(#prompt, or: $value.prompt),
      description: data.get(#description, or: $value.description),
      isRequired: data.get(#isRequired, or: $value.isRequired),
      minValue: data.get(#minValue, or: $value.minValue),
      maxValue: data.get(#maxValue, or: $value.maxValue),
      step: data.get(#step, or: $value.step));

  @override
  SurveyNumberInputBlockCopyWith<$R2, SurveyNumberInputBlock, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _SurveyNumberInputBlockCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
