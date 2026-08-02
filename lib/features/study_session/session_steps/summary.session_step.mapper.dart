// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'summary.session_step.dart';

class SummarySessionStepMapper extends SubClassMapperBase<SummarySessionStep> {
  SummarySessionStepMapper._();

  static SummarySessionStepMapper? _instance;
  static SummarySessionStepMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SummarySessionStepMapper._());
      SessionStepMapper.ensureInitialized().addSubMapper(_instance!);
    }
    return _instance!;
  }

  @override
  final String id = 'SummarySessionStep';

  static String _$id(SummarySessionStep v) => v.id;
  static const Field<SummarySessionStep, String> _f$id = Field('id', _$id);
  static String? _$insertedByRuleId(SummarySessionStep v) => v.insertedByRuleId;
  static const Field<SummarySessionStep, String> _f$insertedByRuleId = Field(
      'insertedByRuleId', _$insertedByRuleId,
      key: r'inserted_by_rule_id', opt: true);
  static String? _$insertionReason(SummarySessionStep v) => v.insertionReason;
  static const Field<SummarySessionStep, String> _f$insertionReason = Field(
      'insertionReason', _$insertionReason,
      key: r'insertion_reason', opt: true);

  @override
  final MappableFields<SummarySessionStep> fields = const {
    #id: _f$id,
    #insertedByRuleId: _f$insertedByRuleId,
    #insertionReason: _f$insertionReason,
  };

  @override
  final String discriminatorKey = 'step_type';
  @override
  final dynamic discriminatorValue = 'summary';
  @override
  late final ClassMapperBase superMapper =
      SessionStepMapper.ensureInitialized();

  static SummarySessionStep _instantiate(DecodingData data) {
    return SummarySessionStep(
        id: data.dec(_f$id),
        insertedByRuleId: data.dec(_f$insertedByRuleId),
        insertionReason: data.dec(_f$insertionReason));
  }

  @override
  final Function instantiate = _instantiate;

  static SummarySessionStep fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SummarySessionStep>(map);
  }

  static SummarySessionStep fromJson(String json) {
    return ensureInitialized().decodeJson<SummarySessionStep>(json);
  }
}

mixin SummarySessionStepMappable {
  String toJson() {
    return SummarySessionStepMapper.ensureInitialized()
        .encodeJson<SummarySessionStep>(this as SummarySessionStep);
  }

  Map<String, dynamic> toMap() {
    return SummarySessionStepMapper.ensureInitialized()
        .encodeMap<SummarySessionStep>(this as SummarySessionStep);
  }

  SummarySessionStepCopyWith<SummarySessionStep, SummarySessionStep,
          SummarySessionStep>
      get copyWith => _SummarySessionStepCopyWithImpl<SummarySessionStep,
          SummarySessionStep>(this as SummarySessionStep, $identity, $identity);
  @override
  String toString() {
    return SummarySessionStepMapper.ensureInitialized()
        .stringifyValue(this as SummarySessionStep);
  }

  @override
  bool operator ==(Object other) {
    return SummarySessionStepMapper.ensureInitialized()
        .equalsValue(this as SummarySessionStep, other);
  }

  @override
  int get hashCode {
    return SummarySessionStepMapper.ensureInitialized()
        .hashValue(this as SummarySessionStep);
  }
}

extension SummarySessionStepValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SummarySessionStep, $Out> {
  SummarySessionStepCopyWith<$R, SummarySessionStep, $Out>
      get $asSummarySessionStep => $base.as(
          (v, t, t2) => _SummarySessionStepCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SummarySessionStepCopyWith<$R, $In extends SummarySessionStep,
    $Out> implements SessionStepCopyWith<$R, $In, $Out> {
  @override
  $R call({String? id, String? insertedByRuleId, String? insertionReason});
  SummarySessionStepCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _SummarySessionStepCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SummarySessionStep, $Out>
    implements SummarySessionStepCopyWith<$R, SummarySessionStep, $Out> {
  _SummarySessionStepCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SummarySessionStep> $mapper =
      SummarySessionStepMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          Object? insertedByRuleId = $none,
          Object? insertionReason = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (insertedByRuleId != $none) #insertedByRuleId: insertedByRuleId,
        if (insertionReason != $none) #insertionReason: insertionReason
      }));
  @override
  SummarySessionStep $make(CopyWithData data) => SummarySessionStep(
      id: data.get(#id, or: $value.id),
      insertedByRuleId:
          data.get(#insertedByRuleId, or: $value.insertedByRuleId),
      insertionReason: data.get(#insertionReason, or: $value.insertionReason));

  @override
  SummarySessionStepCopyWith<$R2, SummarySessionStep, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _SummarySessionStepCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
