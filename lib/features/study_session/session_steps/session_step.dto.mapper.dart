// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'session_step.dto.dart';

class SessionStepMapper extends ClassMapperBase<SessionStep> {
  SessionStepMapper._();

  static SessionStepMapper? _instance;
  static SessionStepMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SessionStepMapper._());
      CardSessionStepMapper.ensureInitialized();
      MessageSessionStepMapper.ensureInitialized();
      SummarySessionStepMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SessionStep';

  static String _$id(SessionStep v) => v.id;
  static const Field<SessionStep, String> _f$id = Field('id', _$id);
  static String? _$insertedByRuleId(SessionStep v) => v.insertedByRuleId;
  static const Field<SessionStep, String> _f$insertedByRuleId = Field(
      'insertedByRuleId', _$insertedByRuleId,
      key: r'inserted_by_rule_id', opt: true);
  static String? _$insertionReason(SessionStep v) => v.insertionReason;
  static const Field<SessionStep, String> _f$insertionReason = Field(
      'insertionReason', _$insertionReason,
      key: r'insertion_reason', opt: true);

  @override
  final MappableFields<SessionStep> fields = const {
    #id: _f$id,
    #insertedByRuleId: _f$insertedByRuleId,
    #insertionReason: _f$insertionReason,
  };

  static SessionStep _instantiate(DecodingData data) {
    throw MapperException.missingSubclass(
        'SessionStep', 'step_type', '${data.value['step_type']}');
  }

  @override
  final Function instantiate = _instantiate;

  static SessionStep fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SessionStep>(map);
  }

  static SessionStep fromJson(String json) {
    return ensureInitialized().decodeJson<SessionStep>(json);
  }
}

mixin SessionStepMappable {
  String toJson();
  Map<String, dynamic> toMap();
  SessionStepCopyWith<SessionStep, SessionStep, SessionStep> get copyWith;
}

abstract class SessionStepCopyWith<$R, $In extends SessionStep, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? insertedByRuleId, String? insertionReason});
  SessionStepCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}
