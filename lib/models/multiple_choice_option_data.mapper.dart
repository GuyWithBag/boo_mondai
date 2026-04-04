// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'multiple_choice_option_data.dart';

class MultipleChoiceOptionDataMapper
    extends ClassMapperBase<MultipleChoiceOptionData> {
  MultipleChoiceOptionDataMapper._();

  static MultipleChoiceOptionDataMapper? _instance;
  static MultipleChoiceOptionDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = MultipleChoiceOptionDataMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MultipleChoiceOptionData';

  static String _$text(MultipleChoiceOptionData v) => v.text;
  static const Field<MultipleChoiceOptionData, String> _f$text =
      Field('text', _$text);
  static bool _$isCorrect(MultipleChoiceOptionData v) => v.isCorrect;
  static const Field<MultipleChoiceOptionData, bool> _f$isCorrect =
      Field('isCorrect', _$isCorrect);

  @override
  final MappableFields<MultipleChoiceOptionData> fields = const {
    #text: _f$text,
    #isCorrect: _f$isCorrect,
  };

  static MultipleChoiceOptionData _instantiate(DecodingData data) {
    return MultipleChoiceOptionData(
        text: data.dec(_f$text), isCorrect: data.dec(_f$isCorrect));
  }

  @override
  final Function instantiate = _instantiate;

  static MultipleChoiceOptionData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MultipleChoiceOptionData>(map);
  }

  static MultipleChoiceOptionData fromJson(String json) {
    return ensureInitialized().decodeJson<MultipleChoiceOptionData>(json);
  }
}

mixin MultipleChoiceOptionDataMappable {
  String toJson() {
    return MultipleChoiceOptionDataMapper.ensureInitialized()
        .encodeJson<MultipleChoiceOptionData>(this as MultipleChoiceOptionData);
  }

  Map<String, dynamic> toMap() {
    return MultipleChoiceOptionDataMapper.ensureInitialized()
        .encodeMap<MultipleChoiceOptionData>(this as MultipleChoiceOptionData);
  }

  MultipleChoiceOptionDataCopyWith<MultipleChoiceOptionData,
          MultipleChoiceOptionData, MultipleChoiceOptionData>
      get copyWith => _MultipleChoiceOptionDataCopyWithImpl<
              MultipleChoiceOptionData, MultipleChoiceOptionData>(
          this as MultipleChoiceOptionData, $identity, $identity);
  @override
  String toString() {
    return MultipleChoiceOptionDataMapper.ensureInitialized()
        .stringifyValue(this as MultipleChoiceOptionData);
  }

  @override
  bool operator ==(Object other) {
    return MultipleChoiceOptionDataMapper.ensureInitialized()
        .equalsValue(this as MultipleChoiceOptionData, other);
  }

  @override
  int get hashCode {
    return MultipleChoiceOptionDataMapper.ensureInitialized()
        .hashValue(this as MultipleChoiceOptionData);
  }
}

extension MultipleChoiceOptionDataValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MultipleChoiceOptionData, $Out> {
  MultipleChoiceOptionDataCopyWith<$R, MultipleChoiceOptionData, $Out>
      get $asMultipleChoiceOptionData => $base.as((v, t, t2) =>
          _MultipleChoiceOptionDataCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MultipleChoiceOptionDataCopyWith<
    $R,
    $In extends MultipleChoiceOptionData,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? text, bool? isCorrect});
  MultipleChoiceOptionDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _MultipleChoiceOptionDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MultipleChoiceOptionData, $Out>
    implements
        MultipleChoiceOptionDataCopyWith<$R, MultipleChoiceOptionData, $Out> {
  _MultipleChoiceOptionDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MultipleChoiceOptionData> $mapper =
      MultipleChoiceOptionDataMapper.ensureInitialized();
  @override
  $R call({String? text, bool? isCorrect}) => $apply(FieldCopyWithData({
        if (text != null) #text: text,
        if (isCorrect != null) #isCorrect: isCorrect
      }));
  @override
  MultipleChoiceOptionData $make(CopyWithData data) => MultipleChoiceOptionData(
      text: data.get(#text, or: $value.text),
      isCorrect: data.get(#isCorrect, or: $value.isCorrect));

  @override
  MultipleChoiceOptionDataCopyWith<$R2, MultipleChoiceOptionData, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _MultipleChoiceOptionDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
