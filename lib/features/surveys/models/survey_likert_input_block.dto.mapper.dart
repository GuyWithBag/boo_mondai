// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'survey_likert_input_block.dto.dart';

class SurveyLikertInputBlockMapper
    extends SubClassMapperBase<SurveyLikertInputBlock> {
  SurveyLikertInputBlockMapper._();

  static SurveyLikertInputBlockMapper? _instance;
  static SurveyLikertInputBlockMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SurveyLikertInputBlockMapper._());
      SurveyBlockMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'SurveyLikertInputBlock';

  static String _$id(SurveyLikertInputBlock v) => v.id;
  static const Field<SurveyLikertInputBlock, String> _f$id = Field('id', _$id);
  static String _$surveyId(SurveyLikertInputBlock v) => v.surveyId;
  static const Field<SurveyLikertInputBlock, String> _f$surveyId =
      Field('surveyId', _$surveyId, key: r'survey_id');
  static String _$pageId(SurveyLikertInputBlock v) => v.pageId;
  static const Field<SurveyLikertInputBlock, String> _f$pageId =
      Field('pageId', _$pageId, key: r'page_id');
  static int _$position(SurveyLikertInputBlock v) => v.position;
  static const Field<SurveyLikertInputBlock, int> _f$position =
      Field('position', _$position);
  static String _$key(SurveyLikertInputBlock v) => v.key;
  static const Field<SurveyLikertInputBlock, String> _f$key =
      Field('key', _$key);
  static String _$prompt(SurveyLikertInputBlock v) => v.prompt;
  static const Field<SurveyLikertInputBlock, String> _f$prompt =
      Field('prompt', _$prompt);
  static String? _$description(SurveyLikertInputBlock v) => v.description;
  static const Field<SurveyLikertInputBlock, String> _f$description =
      Field('description', _$description, opt: true);
  static bool _$isRequired(SurveyLikertInputBlock v) => v.isRequired;
  static const Field<SurveyLikertInputBlock, bool> _f$isRequired = Field(
      'isRequired', _$isRequired,
      key: r'is_required', opt: true, def: true);
  static int _$minValue(SurveyLikertInputBlock v) => v.minValue;
  static const Field<SurveyLikertInputBlock, int> _f$minValue =
      Field('minValue', _$minValue, key: r'min_value', opt: true, def: 1);
  static int _$maxValue(SurveyLikertInputBlock v) => v.maxValue;
  static const Field<SurveyLikertInputBlock, int> _f$maxValue =
      Field('maxValue', _$maxValue, key: r'max_value', opt: true, def: 5);
  static String? _$minLabel(SurveyLikertInputBlock v) => v.minLabel;
  static const Field<SurveyLikertInputBlock, String> _f$minLabel =
      Field('minLabel', _$minLabel, key: r'min_label', opt: true);
  static String? _$maxLabel(SurveyLikertInputBlock v) => v.maxLabel;
  static const Field<SurveyLikertInputBlock, String> _f$maxLabel =
      Field('maxLabel', _$maxLabel, key: r'max_label', opt: true);

  @override
  final MappableFields<SurveyLikertInputBlock> fields = const {
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
    #minLabel: _f$minLabel,
    #maxLabel: _f$maxLabel,
  };

  @override
  final String discriminatorKey = 'block_type';
  @override
  final dynamic discriminatorValue = 'likert_input';
  @override
  late final ClassMapperBase superMapper =
      SurveyBlockMapper.ensureInitialized();

  static SurveyLikertInputBlock _instantiate(DecodingData data) {
    return SurveyLikertInputBlock(
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
        minLabel: data.dec(_f$minLabel),
        maxLabel: data.dec(_f$maxLabel));
  }

  @override
  final Function instantiate = _instantiate;

  static SurveyLikertInputBlock fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SurveyLikertInputBlock>(map);
  }

  static SurveyLikertInputBlock fromJson(String json) {
    return ensureInitialized().decodeJson<SurveyLikertInputBlock>(json);
  }
}

mixin SurveyLikertInputBlockMappable {
  String toJson() {
    return SurveyLikertInputBlockMapper.ensureInitialized()
        .encodeJson<SurveyLikertInputBlock>(this as SurveyLikertInputBlock);
  }

  Map<String, dynamic> toMap() {
    return SurveyLikertInputBlockMapper.ensureInitialized()
        .encodeMap<SurveyLikertInputBlock>(this as SurveyLikertInputBlock);
  }

  SurveyLikertInputBlockCopyWith<SurveyLikertInputBlock, SurveyLikertInputBlock,
          SurveyLikertInputBlock>
      get copyWith => _SurveyLikertInputBlockCopyWithImpl<
              SurveyLikertInputBlock, SurveyLikertInputBlock>(
          this as SurveyLikertInputBlock, $identity, $identity);
  @override
  String toString() {
    return SurveyLikertInputBlockMapper.ensureInitialized()
        .stringifyValue(this as SurveyLikertInputBlock);
  }

  @override
  bool operator ==(Object other) {
    return SurveyLikertInputBlockMapper.ensureInitialized()
        .equalsValue(this as SurveyLikertInputBlock, other);
  }

  @override
  int get hashCode {
    return SurveyLikertInputBlockMapper.ensureInitialized()
        .hashValue(this as SurveyLikertInputBlock);
  }
}

extension SurveyLikertInputBlockValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SurveyLikertInputBlock, $Out> {
  SurveyLikertInputBlockCopyWith<$R, SurveyLikertInputBlock, $Out>
      get $asSurveyLikertInputBlock => $base.as((v, t, t2) =>
          _SurveyLikertInputBlockCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SurveyLikertInputBlockCopyWith<
    $R,
    $In extends SurveyLikertInputBlock,
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
      int? minValue,
      int? maxValue,
      String? minLabel,
      String? maxLabel});
  SurveyLikertInputBlockCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _SurveyLikertInputBlockCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SurveyLikertInputBlock, $Out>
    implements
        SurveyLikertInputBlockCopyWith<$R, SurveyLikertInputBlock, $Out> {
  _SurveyLikertInputBlockCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SurveyLikertInputBlock> $mapper =
      SurveyLikertInputBlockMapper.ensureInitialized();
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
          int? minValue,
          int? maxValue,
          Object? minLabel = $none,
          Object? maxLabel = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (surveyId != null) #surveyId: surveyId,
        if (pageId != null) #pageId: pageId,
        if (position != null) #position: position,
        if (key != null) #key: key,
        if (prompt != null) #prompt: prompt,
        if (description != $none) #description: description,
        if (isRequired != null) #isRequired: isRequired,
        if (minValue != null) #minValue: minValue,
        if (maxValue != null) #maxValue: maxValue,
        if (minLabel != $none) #minLabel: minLabel,
        if (maxLabel != $none) #maxLabel: maxLabel
      }));
  @override
  SurveyLikertInputBlock $make(CopyWithData data) => SurveyLikertInputBlock(
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
      minLabel: data.get(#minLabel, or: $value.minLabel),
      maxLabel: data.get(#maxLabel, or: $value.maxLabel));

  @override
  SurveyLikertInputBlockCopyWith<$R2, SurveyLikertInputBlock, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _SurveyLikertInputBlockCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
