// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'identification_answer.dto.dart';

class IdentificationAnswerMapper extends ClassMapperBase<IdentificationAnswer> {
  IdentificationAnswerMapper._();

  static IdentificationAnswerMapper? _instance;
  static IdentificationAnswerMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = IdentificationAnswerMapper._());
      CasingTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'IdentificationAnswer';

  static String _$id(IdentificationAnswer v) => v.id;
  static const Field<IdentificationAnswer, String> _f$id = Field('id', _$id);
  static String _$templateId(IdentificationAnswer v) => v.templateId;
  static const Field<IdentificationAnswer, String> _f$templateId =
      Field('templateId', _$templateId, key: r'template_id');
  static int _$displayOrder(IdentificationAnswer v) => v.displayOrder;
  static const Field<IdentificationAnswer, int> _f$displayOrder =
      Field('displayOrder', _$displayOrder, key: r'display_order');
  static String _$answer(IdentificationAnswer v) => v.answer;
  static const Field<IdentificationAnswer, String> _f$answer =
      Field('answer', _$answer);
  static CasingType _$casingType(IdentificationAnswer v) => v.casingType;
  static const Field<IdentificationAnswer, CasingType> _f$casingType = Field(
      'casingType', _$casingType,
      key: r'casing_type', opt: true, def: CasingType.any);

  @override
  final MappableFields<IdentificationAnswer> fields = const {
    #id: _f$id,
    #templateId: _f$templateId,
    #displayOrder: _f$displayOrder,
    #answer: _f$answer,
    #casingType: _f$casingType,
  };

  static IdentificationAnswer _instantiate(DecodingData data) {
    return IdentificationAnswer(
        id: data.dec(_f$id),
        templateId: data.dec(_f$templateId),
        displayOrder: data.dec(_f$displayOrder),
        answer: data.dec(_f$answer),
        casingType: data.dec(_f$casingType));
  }

  @override
  final Function instantiate = _instantiate;

  static IdentificationAnswer fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<IdentificationAnswer>(map);
  }

  static IdentificationAnswer fromJson(String json) {
    return ensureInitialized().decodeJson<IdentificationAnswer>(json);
  }
}

mixin IdentificationAnswerMappable {
  String toJson() {
    return IdentificationAnswerMapper.ensureInitialized()
        .encodeJson<IdentificationAnswer>(this as IdentificationAnswer);
  }

  Map<String, dynamic> toMap() {
    return IdentificationAnswerMapper.ensureInitialized()
        .encodeMap<IdentificationAnswer>(this as IdentificationAnswer);
  }

  IdentificationAnswerCopyWith<IdentificationAnswer, IdentificationAnswer,
      IdentificationAnswer> get copyWith => _IdentificationAnswerCopyWithImpl<
          IdentificationAnswer, IdentificationAnswer>(
      this as IdentificationAnswer, $identity, $identity);
  @override
  String toString() {
    return IdentificationAnswerMapper.ensureInitialized()
        .stringifyValue(this as IdentificationAnswer);
  }

  @override
  bool operator ==(Object other) {
    return IdentificationAnswerMapper.ensureInitialized()
        .equalsValue(this as IdentificationAnswer, other);
  }

  @override
  int get hashCode {
    return IdentificationAnswerMapper.ensureInitialized()
        .hashValue(this as IdentificationAnswer);
  }
}

extension IdentificationAnswerValueCopy<$R, $Out>
    on ObjectCopyWith<$R, IdentificationAnswer, $Out> {
  IdentificationAnswerCopyWith<$R, IdentificationAnswer, $Out>
      get $asIdentificationAnswer => $base.as(
          (v, t, t2) => _IdentificationAnswerCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class IdentificationAnswerCopyWith<
    $R,
    $In extends IdentificationAnswer,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? templateId,
      int? displayOrder,
      String? answer,
      CasingType? casingType});
  IdentificationAnswerCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _IdentificationAnswerCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, IdentificationAnswer, $Out>
    implements IdentificationAnswerCopyWith<$R, IdentificationAnswer, $Out> {
  _IdentificationAnswerCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<IdentificationAnswer> $mapper =
      IdentificationAnswerMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? templateId,
          int? displayOrder,
          String? answer,
          CasingType? casingType}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (templateId != null) #templateId: templateId,
        if (displayOrder != null) #displayOrder: displayOrder,
        if (answer != null) #answer: answer,
        if (casingType != null) #casingType: casingType
      }));
  @override
  IdentificationAnswer $make(CopyWithData data) => IdentificationAnswer(
      id: data.get(#id, or: $value.id),
      templateId: data.get(#templateId, or: $value.templateId),
      displayOrder: data.get(#displayOrder, or: $value.displayOrder),
      answer: data.get(#answer, or: $value.answer),
      casingType: data.get(#casingType, or: $value.casingType));

  @override
  IdentificationAnswerCopyWith<$R2, IdentificationAnswer, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _IdentificationAnswerCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
