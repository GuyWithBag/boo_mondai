// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'identification.answer_key.dto.dart';

class IdentificationAnswerKeyMapper
    extends ClassMapperBase<IdentificationAnswerKey> {
  IdentificationAnswerKeyMapper._();

  static IdentificationAnswerKeyMapper? _instance;
  static IdentificationAnswerKeyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals
          .use(_instance = IdentificationAnswerKeyMapper._());
      CasingTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'IdentificationAnswerKey';

  static String _$id(IdentificationAnswerKey v) => v.id;
  static const Field<IdentificationAnswerKey, String> _f$id = Field('id', _$id);
  static String _$templateId(IdentificationAnswerKey v) => v.templateId;
  static const Field<IdentificationAnswerKey, String> _f$templateId =
      Field('templateId', _$templateId, key: r'template_id');
  static int _$displayOrder(IdentificationAnswerKey v) => v.displayOrder;
  static const Field<IdentificationAnswerKey, int> _f$displayOrder =
      Field('displayOrder', _$displayOrder, key: r'display_order');
  static String _$value(IdentificationAnswerKey v) => v.value;
  static const Field<IdentificationAnswerKey, String> _f$value =
      Field('value', _$value);
  static CasingType _$casingType(IdentificationAnswerKey v) => v.casingType;
  static const Field<IdentificationAnswerKey, CasingType> _f$casingType = Field(
      'casingType', _$casingType,
      key: r'casing_type', opt: true, def: CasingType.any);

  @override
  final MappableFields<IdentificationAnswerKey> fields = const {
    #id: _f$id,
    #templateId: _f$templateId,
    #displayOrder: _f$displayOrder,
    #value: _f$value,
    #casingType: _f$casingType,
  };

  static IdentificationAnswerKey _instantiate(DecodingData data) {
    return IdentificationAnswerKey(
        id: data.dec(_f$id),
        templateId: data.dec(_f$templateId),
        displayOrder: data.dec(_f$displayOrder),
        value: data.dec(_f$value),
        casingType: data.dec(_f$casingType));
  }

  @override
  final Function instantiate = _instantiate;

  static IdentificationAnswerKey fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<IdentificationAnswerKey>(map);
  }

  static IdentificationAnswerKey fromJson(String json) {
    return ensureInitialized().decodeJson<IdentificationAnswerKey>(json);
  }
}

mixin IdentificationAnswerKeyMappable {
  String toJson() {
    return IdentificationAnswerKeyMapper.ensureInitialized()
        .encodeJson<IdentificationAnswerKey>(this as IdentificationAnswerKey);
  }

  Map<String, dynamic> toMap() {
    return IdentificationAnswerKeyMapper.ensureInitialized()
        .encodeMap<IdentificationAnswerKey>(this as IdentificationAnswerKey);
  }

  IdentificationAnswerKeyCopyWith<IdentificationAnswerKey,
          IdentificationAnswerKey, IdentificationAnswerKey>
      get copyWith => _IdentificationAnswerKeyCopyWithImpl<
              IdentificationAnswerKey, IdentificationAnswerKey>(
          this as IdentificationAnswerKey, $identity, $identity);
  @override
  String toString() {
    return IdentificationAnswerKeyMapper.ensureInitialized()
        .stringifyValue(this as IdentificationAnswerKey);
  }

  @override
  bool operator ==(Object other) {
    return IdentificationAnswerKeyMapper.ensureInitialized()
        .equalsValue(this as IdentificationAnswerKey, other);
  }

  @override
  int get hashCode {
    return IdentificationAnswerKeyMapper.ensureInitialized()
        .hashValue(this as IdentificationAnswerKey);
  }
}

extension IdentificationAnswerKeyValueCopy<$R, $Out>
    on ObjectCopyWith<$R, IdentificationAnswerKey, $Out> {
  IdentificationAnswerKeyCopyWith<$R, IdentificationAnswerKey, $Out>
      get $asIdentificationAnswerKey => $base.as((v, t, t2) =>
          _IdentificationAnswerKeyCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class IdentificationAnswerKeyCopyWith<
    $R,
    $In extends IdentificationAnswerKey,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? templateId,
      int? displayOrder,
      String? value,
      CasingType? casingType});
  IdentificationAnswerKeyCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _IdentificationAnswerKeyCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, IdentificationAnswerKey, $Out>
    implements
        IdentificationAnswerKeyCopyWith<$R, IdentificationAnswerKey, $Out> {
  _IdentificationAnswerKeyCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<IdentificationAnswerKey> $mapper =
      IdentificationAnswerKeyMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? templateId,
          int? displayOrder,
          String? value,
          CasingType? casingType}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (templateId != null) #templateId: templateId,
        if (displayOrder != null) #displayOrder: displayOrder,
        if (value != null) #value: value,
        if (casingType != null) #casingType: casingType
      }));
  @override
  IdentificationAnswerKey $make(CopyWithData data) => IdentificationAnswerKey(
      id: data.get(#id, or: $value.id),
      templateId: data.get(#templateId, or: $value.templateId),
      displayOrder: data.get(#displayOrder, or: $value.displayOrder),
      value: data.get(#value, or: $value.value),
      casingType: data.get(#casingType, or: $value.casingType));

  @override
  IdentificationAnswerKeyCopyWith<$R2, IdentificationAnswerKey, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _IdentificationAnswerKeyCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
