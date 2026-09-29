// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'fill_in_the_blank.answer_key.dto.dart';

class FillInTheBlankAnswerKeyMapper
    extends ClassMapperBase<FillInTheBlankAnswerKey> {
  FillInTheBlankAnswerKeyMapper._();

  static FillInTheBlankAnswerKeyMapper? _instance;
  static FillInTheBlankAnswerKeyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = FillInTheBlankAnswerKeyMapper._());
      CasingTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'FillInTheBlankAnswerKey';

  static CasingType _$casingType(FillInTheBlankAnswerKey v) => v.casingType;
  static const Field<FillInTheBlankAnswerKey, CasingType> _f$casingType =
      Field('casingType', _$casingType, key: r'casing_type');
  static String _$value(FillInTheBlankAnswerKey v) => v.value;
  static const Field<FillInTheBlankAnswerKey, String> _f$value =
      Field('value', _$value);
  static int _$order(FillInTheBlankAnswerKey v) => v.order;
  static const Field<FillInTheBlankAnswerKey, int> _f$order =
      Field('order', _$order);

  @override
  final MappableFields<FillInTheBlankAnswerKey> fields = const {
    #casingType: _f$casingType,
    #value: _f$value,
    #order: _f$order,
  };

  static FillInTheBlankAnswerKey _instantiate(DecodingData data) {
    return FillInTheBlankAnswerKey(
        casingType: data.dec(_f$casingType),
        value: data.dec(_f$value),
        order: data.dec(_f$order));
  }

  @override
  final Function instantiate = _instantiate;

  static FillInTheBlankAnswerKey fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FillInTheBlankAnswerKey>(map);
  }

  static FillInTheBlankAnswerKey fromJson(String json) {
    return ensureInitialized().decodeJson<FillInTheBlankAnswerKey>(json);
  }
}

mixin FillInTheBlankAnswerKeyMappable {
  String toJson() {
    return FillInTheBlankAnswerKeyMapper.ensureInitialized()
        .encodeJson<FillInTheBlankAnswerKey>(this as FillInTheBlankAnswerKey);
  }

  Map<String, dynamic> toMap() {
    return FillInTheBlankAnswerKeyMapper.ensureInitialized()
        .encodeMap<FillInTheBlankAnswerKey>(this as FillInTheBlankAnswerKey);
  }

  FillInTheBlankAnswerKeyCopyWith<FillInTheBlankAnswerKey,
          FillInTheBlankAnswerKey, FillInTheBlankAnswerKey>
      get copyWith => _FillInTheBlankAnswerKeyCopyWithImpl<
              FillInTheBlankAnswerKey, FillInTheBlankAnswerKey>(
          this as FillInTheBlankAnswerKey, $identity, $identity);
  @override
  String toString() {
    return FillInTheBlankAnswerKeyMapper.ensureInitialized()
        .stringifyValue(this as FillInTheBlankAnswerKey);
  }

  @override
  bool operator ==(Object other) {
    return FillInTheBlankAnswerKeyMapper.ensureInitialized()
        .equalsValue(this as FillInTheBlankAnswerKey, other);
  }

  @override
  int get hashCode {
    return FillInTheBlankAnswerKeyMapper.ensureInitialized()
        .hashValue(this as FillInTheBlankAnswerKey);
  }
}

extension FillInTheBlankAnswerKeyValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FillInTheBlankAnswerKey, $Out> {
  FillInTheBlankAnswerKeyCopyWith<$R, FillInTheBlankAnswerKey, $Out>
      get $asFillInTheBlankAnswerKey => $base.as((v, t, t2) =>
          _FillInTheBlankAnswerKeyCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FillInTheBlankAnswerKeyCopyWith<
    $R,
    $In extends FillInTheBlankAnswerKey,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({CasingType? casingType, String? value, int? order});
  FillInTheBlankAnswerKeyCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _FillInTheBlankAnswerKeyCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FillInTheBlankAnswerKey, $Out>
    implements
        FillInTheBlankAnswerKeyCopyWith<$R, FillInTheBlankAnswerKey, $Out> {
  _FillInTheBlankAnswerKeyCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FillInTheBlankAnswerKey> $mapper =
      FillInTheBlankAnswerKeyMapper.ensureInitialized();
  @override
  $R call({CasingType? casingType, String? value, int? order}) =>
      $apply(FieldCopyWithData({
        if (casingType != null) #casingType: casingType,
        if (value != null) #value: value,
        if (order != null) #order: order
      }));
  @override
  FillInTheBlankAnswerKey $make(CopyWithData data) => FillInTheBlankAnswerKey(
      casingType: data.get(#casingType, or: $value.casingType),
      value: data.get(#value, or: $value.value),
      order: data.get(#order, or: $value.order));

  @override
  FillInTheBlankAnswerKeyCopyWith<$R2, FillInTheBlankAnswerKey, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _FillInTheBlankAnswerKeyCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
