// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'survey_choice_option.dto.dart';

class SurveyChoiceOptionMapper extends ClassMapperBase<SurveyChoiceOption> {
  SurveyChoiceOptionMapper._();

  static SurveyChoiceOptionMapper? _instance;
  static SurveyChoiceOptionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SurveyChoiceOptionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SurveyChoiceOption';

  static String _$id(SurveyChoiceOption v) => v.id;
  static const Field<SurveyChoiceOption, String> _f$id = Field('id', _$id);
  static String _$blockId(SurveyChoiceOption v) => v.blockId;
  static const Field<SurveyChoiceOption, String> _f$blockId =
      Field('blockId', _$blockId, key: r'block_id');
  static int _$position(SurveyChoiceOption v) => v.position;
  static const Field<SurveyChoiceOption, int> _f$position =
      Field('position', _$position);
  static String _$value(SurveyChoiceOption v) => v.value;
  static const Field<SurveyChoiceOption, String> _f$value =
      Field('value', _$value);
  static String _$label(SurveyChoiceOption v) => v.label;
  static const Field<SurveyChoiceOption, String> _f$label =
      Field('label', _$label);

  @override
  final MappableFields<SurveyChoiceOption> fields = const {
    #id: _f$id,
    #blockId: _f$blockId,
    #position: _f$position,
    #value: _f$value,
    #label: _f$label,
  };

  static SurveyChoiceOption _instantiate(DecodingData data) {
    return SurveyChoiceOption(
        id: data.dec(_f$id),
        blockId: data.dec(_f$blockId),
        position: data.dec(_f$position),
        value: data.dec(_f$value),
        label: data.dec(_f$label));
  }

  @override
  final Function instantiate = _instantiate;

  static SurveyChoiceOption fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SurveyChoiceOption>(map);
  }

  static SurveyChoiceOption fromJson(String json) {
    return ensureInitialized().decodeJson<SurveyChoiceOption>(json);
  }
}

mixin SurveyChoiceOptionMappable {
  String toJson() {
    return SurveyChoiceOptionMapper.ensureInitialized()
        .encodeJson<SurveyChoiceOption>(this as SurveyChoiceOption);
  }

  Map<String, dynamic> toMap() {
    return SurveyChoiceOptionMapper.ensureInitialized()
        .encodeMap<SurveyChoiceOption>(this as SurveyChoiceOption);
  }

  SurveyChoiceOptionCopyWith<SurveyChoiceOption, SurveyChoiceOption,
          SurveyChoiceOption>
      get copyWith => _SurveyChoiceOptionCopyWithImpl<SurveyChoiceOption,
          SurveyChoiceOption>(this as SurveyChoiceOption, $identity, $identity);
  @override
  String toString() {
    return SurveyChoiceOptionMapper.ensureInitialized()
        .stringifyValue(this as SurveyChoiceOption);
  }

  @override
  bool operator ==(Object other) {
    return SurveyChoiceOptionMapper.ensureInitialized()
        .equalsValue(this as SurveyChoiceOption, other);
  }

  @override
  int get hashCode {
    return SurveyChoiceOptionMapper.ensureInitialized()
        .hashValue(this as SurveyChoiceOption);
  }
}

extension SurveyChoiceOptionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SurveyChoiceOption, $Out> {
  SurveyChoiceOptionCopyWith<$R, SurveyChoiceOption, $Out>
      get $asSurveyChoiceOption => $base.as(
          (v, t, t2) => _SurveyChoiceOptionCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SurveyChoiceOptionCopyWith<$R, $In extends SurveyChoiceOption,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? blockId,
      int? position,
      String? value,
      String? label});
  SurveyChoiceOptionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _SurveyChoiceOptionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SurveyChoiceOption, $Out>
    implements SurveyChoiceOptionCopyWith<$R, SurveyChoiceOption, $Out> {
  _SurveyChoiceOptionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SurveyChoiceOption> $mapper =
      SurveyChoiceOptionMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? blockId,
          int? position,
          String? value,
          String? label}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (blockId != null) #blockId: blockId,
        if (position != null) #position: position,
        if (value != null) #value: value,
        if (label != null) #label: label
      }));
  @override
  SurveyChoiceOption $make(CopyWithData data) => SurveyChoiceOption(
      id: data.get(#id, or: $value.id),
      blockId: data.get(#blockId, or: $value.blockId),
      position: data.get(#position, or: $value.position),
      value: data.get(#value, or: $value.value),
      label: data.get(#label, or: $value.label));

  @override
  SurveyChoiceOptionCopyWith<$R2, SurveyChoiceOption, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _SurveyChoiceOptionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
