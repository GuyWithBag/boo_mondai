// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'session_flow_snapshot.dto.dart';

class PendingStepSubmissionMapper
    extends ClassMapperBase<PendingStepSubmission> {
  PendingStepSubmissionMapper._();

  static PendingStepSubmissionMapper? _instance;
  static PendingStepSubmissionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PendingStepSubmissionMapper._());
      StudyRatingMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PendingStepSubmission';

  static String _$stepId(PendingStepSubmission v) => v.stepId;
  static const Field<PendingStepSubmission, String> _f$stepId = Field(
    'stepId',
    _$stepId,
    key: r'step_id',
  );
  static String _$userAnswer(PendingStepSubmission v) => v.userAnswer;
  static const Field<PendingStepSubmission, String> _f$userAnswer = Field(
    'userAnswer',
    _$userAnswer,
    key: r'user_answer',
  );
  static StudyRating _$rating(PendingStepSubmission v) => v.rating;
  static const Field<PendingStepSubmission, StudyRating> _f$rating = Field(
    'rating',
    _$rating,
  );
  static DateTime _$submittedAt(PendingStepSubmission v) => v.submittedAt;
  static const Field<PendingStepSubmission, DateTime> _f$submittedAt = Field(
    'submittedAt',
    _$submittedAt,
    key: r'submitted_at',
  );

  @override
  final MappableFields<PendingStepSubmission> fields = const {
    #stepId: _f$stepId,
    #userAnswer: _f$userAnswer,
    #rating: _f$rating,
    #submittedAt: _f$submittedAt,
  };

  static PendingStepSubmission _instantiate(DecodingData data) {
    return PendingStepSubmission(
      stepId: data.dec(_f$stepId),
      userAnswer: data.dec(_f$userAnswer),
      rating: data.dec(_f$rating),
      submittedAt: data.dec(_f$submittedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PendingStepSubmission fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PendingStepSubmission>(map);
  }

  static PendingStepSubmission fromJson(String json) {
    return ensureInitialized().decodeJson<PendingStepSubmission>(json);
  }
}

mixin PendingStepSubmissionMappable {
  String toJson() {
    return PendingStepSubmissionMapper.ensureInitialized()
        .encodeJson<PendingStepSubmission>(this as PendingStepSubmission);
  }

  Map<String, dynamic> toMap() {
    return PendingStepSubmissionMapper.ensureInitialized()
        .encodeMap<PendingStepSubmission>(this as PendingStepSubmission);
  }

  PendingStepSubmissionCopyWith<
    PendingStepSubmission,
    PendingStepSubmission,
    PendingStepSubmission
  >
  get copyWith =>
      _PendingStepSubmissionCopyWithImpl<
        PendingStepSubmission,
        PendingStepSubmission
      >(this as PendingStepSubmission, $identity, $identity);
  @override
  String toString() {
    return PendingStepSubmissionMapper.ensureInitialized().stringifyValue(
      this as PendingStepSubmission,
    );
  }

  @override
  bool operator ==(Object other) {
    return PendingStepSubmissionMapper.ensureInitialized().equalsValue(
      this as PendingStepSubmission,
      other,
    );
  }

  @override
  int get hashCode {
    return PendingStepSubmissionMapper.ensureInitialized().hashValue(
      this as PendingStepSubmission,
    );
  }
}

extension PendingStepSubmissionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PendingStepSubmission, $Out> {
  PendingStepSubmissionCopyWith<$R, PendingStepSubmission, $Out>
  get $asPendingStepSubmission => $base.as(
    (v, t, t2) => _PendingStepSubmissionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PendingStepSubmissionCopyWith<
  $R,
  $In extends PendingStepSubmission,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? stepId,
    String? userAnswer,
    StudyRating? rating,
    DateTime? submittedAt,
  });
  PendingStepSubmissionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PendingStepSubmissionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PendingStepSubmission, $Out>
    implements PendingStepSubmissionCopyWith<$R, PendingStepSubmission, $Out> {
  _PendingStepSubmissionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PendingStepSubmission> $mapper =
      PendingStepSubmissionMapper.ensureInitialized();
  @override
  $R call({
    String? stepId,
    String? userAnswer,
    StudyRating? rating,
    DateTime? submittedAt,
  }) => $apply(
    FieldCopyWithData({
      if (stepId != null) #stepId: stepId,
      if (userAnswer != null) #userAnswer: userAnswer,
      if (rating != null) #rating: rating,
      if (submittedAt != null) #submittedAt: submittedAt,
    }),
  );
  @override
  PendingStepSubmission $make(CopyWithData data) => PendingStepSubmission(
    stepId: data.get(#stepId, or: $value.stepId),
    userAnswer: data.get(#userAnswer, or: $value.userAnswer),
    rating: data.get(#rating, or: $value.rating),
    submittedAt: data.get(#submittedAt, or: $value.submittedAt),
  );

  @override
  PendingStepSubmissionCopyWith<$R2, PendingStepSubmission, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PendingStepSubmissionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SessionFlowSnapshotMapper extends ClassMapperBase<SessionFlowSnapshot> {
  SessionFlowSnapshotMapper._();

  static SessionFlowSnapshotMapper? _instance;
  static SessionFlowSnapshotMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SessionFlowSnapshotMapper._());
      SessionStepMapper.ensureInitialized();
      PendingStepSubmissionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SessionFlowSnapshot';

  static String _$sessionId(SessionFlowSnapshot v) => v.sessionId;
  static const Field<SessionFlowSnapshot, String> _f$sessionId = Field(
    'sessionId',
    _$sessionId,
    key: r'session_id',
  );
  static String? _$currentStepId(SessionFlowSnapshot v) => v.currentStepId;
  static const Field<SessionFlowSnapshot, String> _f$currentStepId = Field(
    'currentStepId',
    _$currentStepId,
    key: r'current_step_id',
  );
  static List<SessionStep> _$steps(SessionFlowSnapshot v) => v.steps;
  static const Field<SessionFlowSnapshot, List<SessionStep>> _f$steps = Field(
    'steps',
    _$steps,
  );
  static Set<String> _$firedRuleKeys(SessionFlowSnapshot v) => v.firedRuleKeys;
  static const Field<SessionFlowSnapshot, Set<String>> _f$firedRuleKeys = Field(
    'firedRuleKeys',
    _$firedRuleKeys,
    key: r'fired_rule_keys',
    opt: true,
    def: const {},
  );
  static PendingStepSubmission? _$pendingSubmission(SessionFlowSnapshot v) =>
      v.pendingSubmission;
  static const Field<SessionFlowSnapshot, PendingStepSubmission>
  _f$pendingSubmission = Field(
    'pendingSubmission',
    _$pendingSubmission,
    key: r'pending_submission',
    opt: true,
  );
  static DateTime _$updatedAt(SessionFlowSnapshot v) => v.updatedAt;
  static const Field<SessionFlowSnapshot, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
    key: r'updated_at',
  );

  @override
  final MappableFields<SessionFlowSnapshot> fields = const {
    #sessionId: _f$sessionId,
    #currentStepId: _f$currentStepId,
    #steps: _f$steps,
    #firedRuleKeys: _f$firedRuleKeys,
    #pendingSubmission: _f$pendingSubmission,
    #updatedAt: _f$updatedAt,
  };

  static SessionFlowSnapshot _instantiate(DecodingData data) {
    return SessionFlowSnapshot(
      sessionId: data.dec(_f$sessionId),
      currentStepId: data.dec(_f$currentStepId),
      steps: data.dec(_f$steps),
      firedRuleKeys: data.dec(_f$firedRuleKeys),
      pendingSubmission: data.dec(_f$pendingSubmission),
      updatedAt: data.dec(_f$updatedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SessionFlowSnapshot fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SessionFlowSnapshot>(map);
  }

  static SessionFlowSnapshot fromJson(String json) {
    return ensureInitialized().decodeJson<SessionFlowSnapshot>(json);
  }
}

mixin SessionFlowSnapshotMappable {
  String toJson() {
    return SessionFlowSnapshotMapper.ensureInitialized()
        .encodeJson<SessionFlowSnapshot>(this as SessionFlowSnapshot);
  }

  Map<String, dynamic> toMap() {
    return SessionFlowSnapshotMapper.ensureInitialized()
        .encodeMap<SessionFlowSnapshot>(this as SessionFlowSnapshot);
  }

  SessionFlowSnapshotCopyWith<
    SessionFlowSnapshot,
    SessionFlowSnapshot,
    SessionFlowSnapshot
  >
  get copyWith =>
      _SessionFlowSnapshotCopyWithImpl<
        SessionFlowSnapshot,
        SessionFlowSnapshot
      >(this as SessionFlowSnapshot, $identity, $identity);
  @override
  String toString() {
    return SessionFlowSnapshotMapper.ensureInitialized().stringifyValue(
      this as SessionFlowSnapshot,
    );
  }

  @override
  bool operator ==(Object other) {
    return SessionFlowSnapshotMapper.ensureInitialized().equalsValue(
      this as SessionFlowSnapshot,
      other,
    );
  }

  @override
  int get hashCode {
    return SessionFlowSnapshotMapper.ensureInitialized().hashValue(
      this as SessionFlowSnapshot,
    );
  }
}

extension SessionFlowSnapshotValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SessionFlowSnapshot, $Out> {
  SessionFlowSnapshotCopyWith<$R, SessionFlowSnapshot, $Out>
  get $asSessionFlowSnapshot => $base.as(
    (v, t, t2) => _SessionFlowSnapshotCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SessionFlowSnapshotCopyWith<
  $R,
  $In extends SessionFlowSnapshot,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    SessionStep,
    SessionStepCopyWith<$R, SessionStep, SessionStep>
  >
  get steps;
  PendingStepSubmissionCopyWith<
    $R,
    PendingStepSubmission,
    PendingStepSubmission
  >?
  get pendingSubmission;
  $R call({
    String? sessionId,
    String? currentStepId,
    List<SessionStep>? steps,
    Set<String>? firedRuleKeys,
    PendingStepSubmission? pendingSubmission,
    DateTime? updatedAt,
  });
  SessionFlowSnapshotCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SessionFlowSnapshotCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SessionFlowSnapshot, $Out>
    implements SessionFlowSnapshotCopyWith<$R, SessionFlowSnapshot, $Out> {
  _SessionFlowSnapshotCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SessionFlowSnapshot> $mapper =
      SessionFlowSnapshotMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    SessionStep,
    SessionStepCopyWith<$R, SessionStep, SessionStep>
  >
  get steps => ListCopyWith(
    $value.steps,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(steps: v),
  );
  @override
  PendingStepSubmissionCopyWith<
    $R,
    PendingStepSubmission,
    PendingStepSubmission
  >?
  get pendingSubmission => $value.pendingSubmission?.copyWith.$chain(
    (v) => call(pendingSubmission: v),
  );
  @override
  $R call({
    String? sessionId,
    Object? currentStepId = $none,
    List<SessionStep>? steps,
    Set<String>? firedRuleKeys,
    Object? pendingSubmission = $none,
    DateTime? updatedAt,
  }) => $apply(
    FieldCopyWithData({
      if (sessionId != null) #sessionId: sessionId,
      if (currentStepId != $none) #currentStepId: currentStepId,
      if (steps != null) #steps: steps,
      if (firedRuleKeys != null) #firedRuleKeys: firedRuleKeys,
      if (pendingSubmission != $none) #pendingSubmission: pendingSubmission,
      if (updatedAt != null) #updatedAt: updatedAt,
    }),
  );
  @override
  SessionFlowSnapshot $make(CopyWithData data) => SessionFlowSnapshot(
    sessionId: data.get(#sessionId, or: $value.sessionId),
    currentStepId: data.get(#currentStepId, or: $value.currentStepId),
    steps: data.get(#steps, or: $value.steps),
    firedRuleKeys: data.get(#firedRuleKeys, or: $value.firedRuleKeys),
    pendingSubmission: data.get(
      #pendingSubmission,
      or: $value.pendingSubmission,
    ),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
  );

  @override
  SessionFlowSnapshotCopyWith<$R2, SessionFlowSnapshot, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SessionFlowSnapshotCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
