// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'survey_boolean_input_block.dto.dart';

class SurveyBooleanInputBlockMapper
    extends SubClassMapperBase<SurveyBooleanInputBlock> {
  SurveyBooleanInputBlockMapper._();

  static SurveyBooleanInputBlockMapper? _instance;
  static SurveyBooleanInputBlockMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = SurveyBooleanInputBlockMapper._());
      SurveyBlockMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'SurveyBooleanInputBlock';

  static String _$id(SurveyBooleanInputBlock v) => v.id;
  static const Field<SurveyBooleanInputBlock, String> _f$id = Field('id', _$id);
  static String _$surveyId(SurveyBooleanInputBlock v) => v.surveyId;
  static const Field<SurveyBooleanInputBlock, String> _f$surveyId =
      Field('surveyId', _$surveyId, key: r'survey_id');
  static String _$pageId(SurveyBooleanInputBlock v) => v.pageId;
  static const Field<SurveyBooleanInputBlock, String> _f$pageId =
      Field('pageId', _$pageId, key: r'page_id');
  static int _$position(SurveyBooleanInputBlock v) => v.position;
  static const Field<SurveyBooleanInputBlock, int> _f$position =
      Field('position', _$position);
  static String _$key(SurveyBooleanInputBlock v) => v.key;
  static const Field<SurveyBooleanInputBlock, String> _f$key =
      Field('key', _$key);
  static String _$prompt(SurveyBooleanInputBlock v) => v.prompt;
  static const Field<SurveyBooleanInputBlock, String> _f$prompt =
      Field('prompt', _$prompt);
  static String? _$description(SurveyBooleanInputBlock v) => v.description;
  static const Field<SurveyBooleanInputBlock, String> _f$description =
      Field('description', _$description, opt: true);
  static bool _$isRequired(SurveyBooleanInputBlock v) => v.isRequired;
  static const Field<SurveyBooleanInputBlock, bool> _f$isRequired = Field(
      'isRequired', _$isRequired,
      key: r'is_required', opt: true, def: true);
  static String _$trueLabel(SurveyBooleanInputBlock v) => v.trueLabel;
  static const Field<SurveyBooleanInputBlock, String> _f$trueLabel = Field(
      'trueLabel', _$trueLabel,
      key: r'true_label', opt: true, def: 'Yes');
  static String _$falseLabel(SurveyBooleanInputBlock v) => v.falseLabel;
  static const Field<SurveyBooleanInputBlock, String> _f$falseLabel = Field(
      'falseLabel', _$falseLabel,
      key: r'false_label', opt: true, def: 'No');

  @override
  final MappableFields<SurveyBooleanInputBlock> fields = const {
    #id: _f$id,
    #surveyId: _f$surveyId,
    #pageId: _f$pageId,
    #position: _f$position,
    #key: _f$key,
    #prompt: _f$prompt,
    #description: _f$description,
    #isRequired: _f$isRequired,
    #trueLabel: _f$trueLabel,
    #falseLabel: _f$falseLabel,
  };

  @override
  final String discriminatorKey = 'block_type';
  @override
  final dynamic discriminatorValue = 'boolean_input';
  @override
  late final ClassMapperBase superMapper =
      SurveyBlockMapper.ensureInitialized();

  static SurveyBooleanInputBlock _instantiate(DecodingData data) {
    return SurveyBooleanInputBlock(
        id: data.dec(_f$id),
        surveyId: data.dec(_f$surveyId),
        pageId: data.dec(_f$pageId),
        position: data.dec(_f$position),
        key: data.dec(_f$key),
        prompt: data.dec(_f$prompt),
        description: data.dec(_f$description),
        isRequired: data.dec(_f$isRequired),
        trueLabel: data.dec(_f$trueLabel),
        falseLabel: data.dec(_f$falseLabel));
  }

  @override
  final Function instantiate = _instantiate;

  static SurveyBooleanInputBlock fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SurveyBooleanInputBlock>(map);
  }

  static SurveyBooleanInputBlock fromJson(String json) {
    return ensureInitialized().decodeJson<SurveyBooleanInputBlock>(json);
  }
}

mixin SurveyBooleanInputBlockMappable {
  String toJson() {
    return SurveyBooleanInputBlockMapper.ensureInitialized()
        .encodeJson<SurveyBooleanInputBlock>(this as SurveyBooleanInputBlock);
  }

  Map<String, dynamic> toMap() {
    return SurveyBooleanInputBlockMapper.ensureInitialized()
        .encodeMap<SurveyBooleanInputBlock>(this as SurveyBooleanInputBlock);
  }

  SurveyBooleanInputBlockCopyWith<SurveyBooleanInputBlock,
          SurveyBooleanInputBlock, SurveyBooleanInputBlock>
      get copyWith => _SurveyBooleanInputBlockCopyWithImpl<
              SurveyBooleanInputBlock, SurveyBooleanInputBlock>(
          this as SurveyBooleanInputBlock, $identity, $identity);
  @override
  String toString() {
    return SurveyBooleanInputBlockMapper.ensureInitialized()
        .stringifyValue(this as SurveyBooleanInputBlock);
  }

  @override
  bool operator ==(Object other) {
    return SurveyBooleanInputBlockMapper.ensureInitialized()
        .equalsValue(this as SurveyBooleanInputBlock, other);
  }

  @override
  int get hashCode {
    return SurveyBooleanInputBlockMapper.ensureInitialized()
        .hashValue(this as SurveyBooleanInputBlock);
  }
}

extension SurveyBooleanInputBlockValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SurveyBooleanInputBlock, $Out> {
  SurveyBooleanInputBlockCopyWith<$R, SurveyBooleanInputBlock, $Out>
      get $asSurveyBooleanInputBlock => $base.as((v, t, t2) =>
          _SurveyBooleanInputBlockCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SurveyBooleanInputBlockCopyWith<
    $R,
    $In extends SurveyBooleanInputBlock,
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
      String? trueLabel,
      String? falseLabel});
  SurveyBooleanInputBlockCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _SurveyBooleanInputBlockCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SurveyBooleanInputBlock, $Out>
    implements
        SurveyBooleanInputBlockCopyWith<$R, SurveyBooleanInputBlock, $Out> {
  _SurveyBooleanInputBlockCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SurveyBooleanInputBlock> $mapper =
      SurveyBooleanInputBlockMapper.ensureInitialized();
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
          String? trueLabel,
          String? falseLabel}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (surveyId != null) #surveyId: surveyId,
        if (pageId != null) #pageId: pageId,
        if (position != null) #position: position,
        if (key != null) #key: key,
        if (prompt != null) #prompt: prompt,
        if (description != $none) #description: description,
        if (isRequired != null) #isRequired: isRequired,
        if (trueLabel != null) #trueLabel: trueLabel,
        if (falseLabel != null) #falseLabel: falseLabel
      }));
  @override
  SurveyBooleanInputBlock $make(CopyWithData data) => SurveyBooleanInputBlock(
      id: data.get(#id, or: $value.id),
      surveyId: data.get(#surveyId, or: $value.surveyId),
      pageId: data.get(#pageId, or: $value.pageId),
      position: data.get(#position, or: $value.position),
      key: data.get(#key, or: $value.key),
      prompt: data.get(#prompt, or: $value.prompt),
      description: data.get(#description, or: $value.description),
      isRequired: data.get(#isRequired, or: $value.isRequired),
      trueLabel: data.get(#trueLabel, or: $value.trueLabel),
      falseLabel: data.get(#falseLabel, or: $value.falseLabel));

  @override
  SurveyBooleanInputBlockCopyWith<$R2, SurveyBooleanInputBlock, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _SurveyBooleanInputBlockCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
