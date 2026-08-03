// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'survey_text_input_block.dto.dart';

class SurveyTextInputBlockMapper
    extends SubClassMapperBase<SurveyTextInputBlock> {
  SurveyTextInputBlockMapper._();

  static SurveyTextInputBlockMapper? _instance;
  static SurveyTextInputBlockMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SurveyTextInputBlockMapper._());
      SurveyBlockMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'SurveyTextInputBlock';

  static String _$id(SurveyTextInputBlock v) => v.id;
  static const Field<SurveyTextInputBlock, String> _f$id = Field('id', _$id);
  static String _$surveyId(SurveyTextInputBlock v) => v.surveyId;
  static const Field<SurveyTextInputBlock, String> _f$surveyId =
      Field('surveyId', _$surveyId, key: r'survey_id');
  static String _$pageId(SurveyTextInputBlock v) => v.pageId;
  static const Field<SurveyTextInputBlock, String> _f$pageId =
      Field('pageId', _$pageId, key: r'page_id');
  static int _$position(SurveyTextInputBlock v) => v.position;
  static const Field<SurveyTextInputBlock, int> _f$position =
      Field('position', _$position);
  static String _$key(SurveyTextInputBlock v) => v.key;
  static const Field<SurveyTextInputBlock, String> _f$key = Field('key', _$key);
  static String _$prompt(SurveyTextInputBlock v) => v.prompt;
  static const Field<SurveyTextInputBlock, String> _f$prompt =
      Field('prompt', _$prompt);
  static String? _$description(SurveyTextInputBlock v) => v.description;
  static const Field<SurveyTextInputBlock, String> _f$description =
      Field('description', _$description, opt: true);
  static bool _$isRequired(SurveyTextInputBlock v) => v.isRequired;
  static const Field<SurveyTextInputBlock, bool> _f$isRequired = Field(
      'isRequired', _$isRequired,
      key: r'is_required', opt: true, def: true);
  static bool _$isLongText(SurveyTextInputBlock v) => v.isLongText;
  static const Field<SurveyTextInputBlock, bool> _f$isLongText = Field(
      'isLongText', _$isLongText,
      key: r'is_long_text', opt: true, def: false);
  static String? _$placeholder(SurveyTextInputBlock v) => v.placeholder;
  static const Field<SurveyTextInputBlock, String> _f$placeholder =
      Field('placeholder', _$placeholder, opt: true);
  static int? _$minLength(SurveyTextInputBlock v) => v.minLength;
  static const Field<SurveyTextInputBlock, int> _f$minLength =
      Field('minLength', _$minLength, key: r'min_length', opt: true);
  static int? _$maxLength(SurveyTextInputBlock v) => v.maxLength;
  static const Field<SurveyTextInputBlock, int> _f$maxLength =
      Field('maxLength', _$maxLength, key: r'max_length', opt: true);

  @override
  final MappableFields<SurveyTextInputBlock> fields = const {
    #id: _f$id,
    #surveyId: _f$surveyId,
    #pageId: _f$pageId,
    #position: _f$position,
    #key: _f$key,
    #prompt: _f$prompt,
    #description: _f$description,
    #isRequired: _f$isRequired,
    #isLongText: _f$isLongText,
    #placeholder: _f$placeholder,
    #minLength: _f$minLength,
    #maxLength: _f$maxLength,
  };

  @override
  final String discriminatorKey = 'block_type';
  @override
  final dynamic discriminatorValue = 'text_input';
  @override
  late final ClassMapperBase superMapper =
      SurveyBlockMapper.ensureInitialized();

  static SurveyTextInputBlock _instantiate(DecodingData data) {
    return SurveyTextInputBlock(
        id: data.dec(_f$id),
        surveyId: data.dec(_f$surveyId),
        pageId: data.dec(_f$pageId),
        position: data.dec(_f$position),
        key: data.dec(_f$key),
        prompt: data.dec(_f$prompt),
        description: data.dec(_f$description),
        isRequired: data.dec(_f$isRequired),
        isLongText: data.dec(_f$isLongText),
        placeholder: data.dec(_f$placeholder),
        minLength: data.dec(_f$minLength),
        maxLength: data.dec(_f$maxLength));
  }

  @override
  final Function instantiate = _instantiate;

  static SurveyTextInputBlock fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SurveyTextInputBlock>(map);
  }

  static SurveyTextInputBlock fromJson(String json) {
    return ensureInitialized().decodeJson<SurveyTextInputBlock>(json);
  }
}

mixin SurveyTextInputBlockMappable {
  String toJson() {
    return SurveyTextInputBlockMapper.ensureInitialized()
        .encodeJson<SurveyTextInputBlock>(this as SurveyTextInputBlock);
  }

  Map<String, dynamic> toMap() {
    return SurveyTextInputBlockMapper.ensureInitialized()
        .encodeMap<SurveyTextInputBlock>(this as SurveyTextInputBlock);
  }

  SurveyTextInputBlockCopyWith<SurveyTextInputBlock, SurveyTextInputBlock,
      SurveyTextInputBlock> get copyWith => _SurveyTextInputBlockCopyWithImpl<
          SurveyTextInputBlock, SurveyTextInputBlock>(
      this as SurveyTextInputBlock, $identity, $identity);
  @override
  String toString() {
    return SurveyTextInputBlockMapper.ensureInitialized()
        .stringifyValue(this as SurveyTextInputBlock);
  }

  @override
  bool operator ==(Object other) {
    return SurveyTextInputBlockMapper.ensureInitialized()
        .equalsValue(this as SurveyTextInputBlock, other);
  }

  @override
  int get hashCode {
    return SurveyTextInputBlockMapper.ensureInitialized()
        .hashValue(this as SurveyTextInputBlock);
  }
}

extension SurveyTextInputBlockValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SurveyTextInputBlock, $Out> {
  SurveyTextInputBlockCopyWith<$R, SurveyTextInputBlock, $Out>
      get $asSurveyTextInputBlock => $base.as(
          (v, t, t2) => _SurveyTextInputBlockCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SurveyTextInputBlockCopyWith<
    $R,
    $In extends SurveyTextInputBlock,
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
      bool? isLongText,
      String? placeholder,
      int? minLength,
      int? maxLength});
  SurveyTextInputBlockCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _SurveyTextInputBlockCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SurveyTextInputBlock, $Out>
    implements SurveyTextInputBlockCopyWith<$R, SurveyTextInputBlock, $Out> {
  _SurveyTextInputBlockCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SurveyTextInputBlock> $mapper =
      SurveyTextInputBlockMapper.ensureInitialized();
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
          bool? isLongText,
          Object? placeholder = $none,
          Object? minLength = $none,
          Object? maxLength = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (surveyId != null) #surveyId: surveyId,
        if (pageId != null) #pageId: pageId,
        if (position != null) #position: position,
        if (key != null) #key: key,
        if (prompt != null) #prompt: prompt,
        if (description != $none) #description: description,
        if (isRequired != null) #isRequired: isRequired,
        if (isLongText != null) #isLongText: isLongText,
        if (placeholder != $none) #placeholder: placeholder,
        if (minLength != $none) #minLength: minLength,
        if (maxLength != $none) #maxLength: maxLength
      }));
  @override
  SurveyTextInputBlock $make(CopyWithData data) => SurveyTextInputBlock(
      id: data.get(#id, or: $value.id),
      surveyId: data.get(#surveyId, or: $value.surveyId),
      pageId: data.get(#pageId, or: $value.pageId),
      position: data.get(#position, or: $value.position),
      key: data.get(#key, or: $value.key),
      prompt: data.get(#prompt, or: $value.prompt),
      description: data.get(#description, or: $value.description),
      isRequired: data.get(#isRequired, or: $value.isRequired),
      isLongText: data.get(#isLongText, or: $value.isLongText),
      placeholder: data.get(#placeholder, or: $value.placeholder),
      minLength: data.get(#minLength, or: $value.minLength),
      maxLength: data.get(#maxLength, or: $value.maxLength));

  @override
  SurveyTextInputBlockCopyWith<$R2, SurveyTextInputBlock, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _SurveyTextInputBlockCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
