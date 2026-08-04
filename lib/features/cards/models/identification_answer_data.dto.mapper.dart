// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'identification_answer_data.dto.dart';

class IdentificationAnswerDataMapper
    extends ClassMapperBase<IdentificationAnswerData> {
  IdentificationAnswerDataMapper._();

  static IdentificationAnswerDataMapper? _instance;
  static IdentificationAnswerDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = IdentificationAnswerDataMapper._());
      CasingTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'IdentificationAnswerData';

  static String _$answer(IdentificationAnswerData v) => v.answer;
  static const Field<IdentificationAnswerData, String> _f$answer =
      Field('answer', _$answer);
  static CasingType _$casingType(IdentificationAnswerData v) => v.casingType;
  static const Field<IdentificationAnswerData, CasingType> _f$casingType =
      Field('casingType', _$casingType,
          key: r'casing_type', opt: true, def: CasingType.any);

  @override
  final MappableFields<IdentificationAnswerData> fields = const {
    #answer: _f$answer,
    #casingType: _f$casingType,
  };

  static IdentificationAnswerData _instantiate(DecodingData data) {
    return IdentificationAnswerData(
        answer: data.dec(_f$answer), casingType: data.dec(_f$casingType));
  }

  @override
  final Function instantiate = _instantiate;

  static IdentificationAnswerData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<IdentificationAnswerData>(map);
  }

  static IdentificationAnswerData fromJson(String json) {
    return ensureInitialized().decodeJson<IdentificationAnswerData>(json);
  }
}

mixin IdentificationAnswerDataMappable {
  String toJson() {
    return IdentificationAnswerDataMapper.ensureInitialized()
        .encodeJson<IdentificationAnswerData>(this as IdentificationAnswerData);
  }

  Map<String, dynamic> toMap() {
    return IdentificationAnswerDataMapper.ensureInitialized()
        .encodeMap<IdentificationAnswerData>(this as IdentificationAnswerData);
  }

  IdentificationAnswerDataCopyWith<IdentificationAnswerData,
          IdentificationAnswerData, IdentificationAnswerData>
      get copyWith => _IdentificationAnswerDataCopyWithImpl<
              IdentificationAnswerData, IdentificationAnswerData>(
          this as IdentificationAnswerData, $identity, $identity);
  @override
  String toString() {
    return IdentificationAnswerDataMapper.ensureInitialized()
        .stringifyValue(this as IdentificationAnswerData);
  }

  @override
  bool operator ==(Object other) {
    return IdentificationAnswerDataMapper.ensureInitialized()
        .equalsValue(this as IdentificationAnswerData, other);
  }

  @override
  int get hashCode {
    return IdentificationAnswerDataMapper.ensureInitialized()
        .hashValue(this as IdentificationAnswerData);
  }
}

extension IdentificationAnswerDataValueCopy<$R, $Out>
    on ObjectCopyWith<$R, IdentificationAnswerData, $Out> {
  IdentificationAnswerDataCopyWith<$R, IdentificationAnswerData, $Out>
      get $asIdentificationAnswerData => $base.as((v, t, t2) =>
          _IdentificationAnswerDataCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class IdentificationAnswerDataCopyWith<
    $R,
    $In extends IdentificationAnswerData,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? answer, CasingType? casingType});
  IdentificationAnswerDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _IdentificationAnswerDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, IdentificationAnswerData, $Out>
    implements
        IdentificationAnswerDataCopyWith<$R, IdentificationAnswerData, $Out> {
  _IdentificationAnswerDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<IdentificationAnswerData> $mapper =
      IdentificationAnswerDataMapper.ensureInitialized();
  @override
  $R call({String? answer, CasingType? casingType}) =>
      $apply(FieldCopyWithData({
        if (answer != null) #answer: answer,
        if (casingType != null) #casingType: casingType
      }));
  @override
  IdentificationAnswerData $make(CopyWithData data) => IdentificationAnswerData(
      answer: data.get(#answer, or: $value.answer),
      casingType: data.get(#casingType, or: $value.casingType));

  @override
  IdentificationAnswerDataCopyWith<$R2, IdentificationAnswerData, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _IdentificationAnswerDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
