// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'card.session_step.dart';

class CardSessionStepMapper extends SubClassMapperBase<CardSessionStep> {
  CardSessionStepMapper._();

  static CardSessionStepMapper? _instance;
  static CardSessionStepMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CardSessionStepMapper._());
      SessionStepMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'CardSessionStep';

  static String _$id(CardSessionStep v) => v.id;
  static const Field<CardSessionStep, String> _f$id = Field('id', _$id);
  static String _$studyCardId(CardSessionStep v) => v.studyCardId;
  static const Field<CardSessionStep, String> _f$studyCardId =
      Field('studyCardId', _$studyCardId, key: r'study_card_id');
  static int _$attemptNumber(CardSessionStep v) => v.attemptNumber;
  static const Field<CardSessionStep, int> _f$attemptNumber = Field(
      'attemptNumber', _$attemptNumber,
      key: r'attempt_number', opt: true, def: 1);
  static String? _$insertedByRuleId(CardSessionStep v) => v.insertedByRuleId;
  static const Field<CardSessionStep, String> _f$insertedByRuleId = Field(
      'insertedByRuleId', _$insertedByRuleId,
      key: r'inserted_by_rule_id', opt: true);
  static String? _$insertionReason(CardSessionStep v) => v.insertionReason;
  static const Field<CardSessionStep, String> _f$insertionReason = Field(
      'insertionReason', _$insertionReason,
      key: r'insertion_reason', opt: true);

  @override
  final MappableFields<CardSessionStep> fields = const {
    #id: _f$id,
    #studyCardId: _f$studyCardId,
    #attemptNumber: _f$attemptNumber,
    #insertedByRuleId: _f$insertedByRuleId,
    #insertionReason: _f$insertionReason,
  };

  @override
  final String discriminatorKey = 'step_type';
  @override
  final dynamic discriminatorValue = 'card';
  @override
  late final ClassMapperBase superMapper =
      SessionStepMapper.ensureInitialized();

  static CardSessionStep _instantiate(DecodingData data) {
    return CardSessionStep(
        id: data.dec(_f$id),
        studyCardId: data.dec(_f$studyCardId),
        attemptNumber: data.dec(_f$attemptNumber),
        insertedByRuleId: data.dec(_f$insertedByRuleId),
        insertionReason: data.dec(_f$insertionReason));
  }

  @override
  final Function instantiate = _instantiate;

  static CardSessionStep fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CardSessionStep>(map);
  }

  static CardSessionStep fromJson(String json) {
    return ensureInitialized().decodeJson<CardSessionStep>(json);
  }
}

mixin CardSessionStepMappable {
  String toJson() {
    return CardSessionStepMapper.ensureInitialized()
        .encodeJson<CardSessionStep>(this as CardSessionStep);
  }

  Map<String, dynamic> toMap() {
    return CardSessionStepMapper.ensureInitialized()
        .encodeMap<CardSessionStep>(this as CardSessionStep);
  }

  CardSessionStepCopyWith<CardSessionStep, CardSessionStep, CardSessionStep>
      get copyWith =>
          _CardSessionStepCopyWithImpl<CardSessionStep, CardSessionStep>(
              this as CardSessionStep, $identity, $identity);
  @override
  String toString() {
    return CardSessionStepMapper.ensureInitialized()
        .stringifyValue(this as CardSessionStep);
  }

  @override
  bool operator ==(Object other) {
    return CardSessionStepMapper.ensureInitialized()
        .equalsValue(this as CardSessionStep, other);
  }

  @override
  int get hashCode {
    return CardSessionStepMapper.ensureInitialized()
        .hashValue(this as CardSessionStep);
  }
}

extension CardSessionStepValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CardSessionStep, $Out> {
  CardSessionStepCopyWith<$R, CardSessionStep, $Out> get $asCardSessionStep =>
      $base.as((v, t, t2) => _CardSessionStepCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class CardSessionStepCopyWith<$R, $In extends CardSessionStep, $Out>
    implements SessionStepCopyWith<$R, $In, $Out> {
  @override
  $R call(
      {String? id,
      String? studyCardId,
      int? attemptNumber,
      String? insertedByRuleId,
      String? insertionReason});
  CardSessionStepCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _CardSessionStepCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CardSessionStep, $Out>
    implements CardSessionStepCopyWith<$R, CardSessionStep, $Out> {
  _CardSessionStepCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CardSessionStep> $mapper =
      CardSessionStepMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? studyCardId,
          int? attemptNumber,
          Object? insertedByRuleId = $none,
          Object? insertionReason = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (studyCardId != null) #studyCardId: studyCardId,
        if (attemptNumber != null) #attemptNumber: attemptNumber,
        if (insertedByRuleId != $none) #insertedByRuleId: insertedByRuleId,
        if (insertionReason != $none) #insertionReason: insertionReason
      }));
  @override
  CardSessionStep $make(CopyWithData data) => CardSessionStep(
      id: data.get(#id, or: $value.id),
      studyCardId: data.get(#studyCardId, or: $value.studyCardId),
      attemptNumber: data.get(#attemptNumber, or: $value.attemptNumber),
      insertedByRuleId:
          data.get(#insertedByRuleId, or: $value.insertedByRuleId),
      insertionReason: data.get(#insertionReason, or: $value.insertionReason));

  @override
  CardSessionStepCopyWith<$R2, CardSessionStep, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _CardSessionStepCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
