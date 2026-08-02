// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'study_session_step_record.dto.dart';

class StudySessionStepRecordMapper
    extends ClassMapperBase<StudySessionStepRecord> {
  StudySessionStepRecordMapper._();

  static StudySessionStepRecordMapper? _instance;
  static StudySessionStepRecordMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StudySessionStepRecordMapper._());
      StudyRatingMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'StudySessionStepRecord';

  static String _$id(StudySessionStepRecord v) => v.id;
  static const Field<StudySessionStepRecord, String> _f$id = Field('id', _$id);
  static String _$sessionId(StudySessionStepRecord v) => v.sessionId;
  static const Field<StudySessionStepRecord, String> _f$sessionId =
      Field('sessionId', _$sessionId, key: r'session_id');
  static String _$stepId(StudySessionStepRecord v) => v.stepId;
  static const Field<StudySessionStepRecord, String> _f$stepId =
      Field('stepId', _$stepId, key: r'step_id');
  static String _$studyCardId(StudySessionStepRecord v) => v.studyCardId;
  static const Field<StudySessionStepRecord, String> _f$studyCardId =
      Field('studyCardId', _$studyCardId, key: r'study_card_id');
  static int _$sequenceNumber(StudySessionStepRecord v) => v.sequenceNumber;
  static const Field<StudySessionStepRecord, int> _f$sequenceNumber =
      Field('sequenceNumber', _$sequenceNumber, key: r'sequence_number');
  static int _$attemptNumber(StudySessionStepRecord v) => v.attemptNumber;
  static const Field<StudySessionStepRecord, int> _f$attemptNumber =
      Field('attemptNumber', _$attemptNumber, key: r'attempt_number');
  static String _$userAnswer(StudySessionStepRecord v) => v.userAnswer;
  static const Field<StudySessionStepRecord, String> _f$userAnswer =
      Field('userAnswer', _$userAnswer, key: r'user_answer');
  static StudyRating _$rating(StudySessionStepRecord v) => v.rating;
  static const Field<StudySessionStepRecord, StudyRating> _f$rating =
      Field('rating', _$rating);
  static DateTime _$enteredAt(StudySessionStepRecord v) => v.enteredAt;
  static const Field<StudySessionStepRecord, DateTime> _f$enteredAt =
      Field('enteredAt', _$enteredAt, key: r'entered_at');
  static DateTime _$completedAt(StudySessionStepRecord v) => v.completedAt;
  static const Field<StudySessionStepRecord, DateTime> _f$completedAt =
      Field('completedAt', _$completedAt, key: r'completed_at');
  static String? _$drillAnswerId(StudySessionStepRecord v) => v.drillAnswerId;
  static const Field<StudySessionStepRecord, String> _f$drillAnswerId = Field(
      'drillAnswerId', _$drillAnswerId,
      key: r'drill_answer_id', opt: true);
  static String? _$fsrsReviewLogId(StudySessionStepRecord v) =>
      v.fsrsReviewLogId;
  static const Field<StudySessionStepRecord, String> _f$fsrsReviewLogId = Field(
      'fsrsReviewLogId', _$fsrsReviewLogId,
      key: r'fsrs_review_log_id', opt: true);

  @override
  final MappableFields<StudySessionStepRecord> fields = const {
    #id: _f$id,
    #sessionId: _f$sessionId,
    #stepId: _f$stepId,
    #studyCardId: _f$studyCardId,
    #sequenceNumber: _f$sequenceNumber,
    #attemptNumber: _f$attemptNumber,
    #userAnswer: _f$userAnswer,
    #rating: _f$rating,
    #enteredAt: _f$enteredAt,
    #completedAt: _f$completedAt,
    #drillAnswerId: _f$drillAnswerId,
    #fsrsReviewLogId: _f$fsrsReviewLogId,
  };

  static StudySessionStepRecord _instantiate(DecodingData data) {
    return StudySessionStepRecord(
        id: data.dec(_f$id),
        sessionId: data.dec(_f$sessionId),
        stepId: data.dec(_f$stepId),
        studyCardId: data.dec(_f$studyCardId),
        sequenceNumber: data.dec(_f$sequenceNumber),
        attemptNumber: data.dec(_f$attemptNumber),
        userAnswer: data.dec(_f$userAnswer),
        rating: data.dec(_f$rating),
        enteredAt: data.dec(_f$enteredAt),
        completedAt: data.dec(_f$completedAt),
        drillAnswerId: data.dec(_f$drillAnswerId),
        fsrsReviewLogId: data.dec(_f$fsrsReviewLogId));
  }

  @override
  final Function instantiate = _instantiate;

  static StudySessionStepRecord fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<StudySessionStepRecord>(map);
  }

  static StudySessionStepRecord fromJson(String json) {
    return ensureInitialized().decodeJson<StudySessionStepRecord>(json);
  }
}

mixin StudySessionStepRecordMappable {
  String toJson() {
    return StudySessionStepRecordMapper.ensureInitialized()
        .encodeJson<StudySessionStepRecord>(this as StudySessionStepRecord);
  }

  Map<String, dynamic> toMap() {
    return StudySessionStepRecordMapper.ensureInitialized()
        .encodeMap<StudySessionStepRecord>(this as StudySessionStepRecord);
  }

  StudySessionStepRecordCopyWith<StudySessionStepRecord, StudySessionStepRecord,
          StudySessionStepRecord>
      get copyWith => _StudySessionStepRecordCopyWithImpl<
              StudySessionStepRecord, StudySessionStepRecord>(
          this as StudySessionStepRecord, $identity, $identity);
  @override
  String toString() {
    return StudySessionStepRecordMapper.ensureInitialized()
        .stringifyValue(this as StudySessionStepRecord);
  }

  @override
  bool operator ==(Object other) {
    return StudySessionStepRecordMapper.ensureInitialized()
        .equalsValue(this as StudySessionStepRecord, other);
  }

  @override
  int get hashCode {
    return StudySessionStepRecordMapper.ensureInitialized()
        .hashValue(this as StudySessionStepRecord);
  }
}

extension StudySessionStepRecordValueCopy<$R, $Out>
    on ObjectCopyWith<$R, StudySessionStepRecord, $Out> {
  StudySessionStepRecordCopyWith<$R, StudySessionStepRecord, $Out>
      get $asStudySessionStepRecord => $base.as((v, t, t2) =>
          _StudySessionStepRecordCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class StudySessionStepRecordCopyWith<
    $R,
    $In extends StudySessionStepRecord,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? sessionId,
      String? stepId,
      String? studyCardId,
      int? sequenceNumber,
      int? attemptNumber,
      String? userAnswer,
      StudyRating? rating,
      DateTime? enteredAt,
      DateTime? completedAt,
      String? drillAnswerId,
      String? fsrsReviewLogId});
  StudySessionStepRecordCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _StudySessionStepRecordCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, StudySessionStepRecord, $Out>
    implements
        StudySessionStepRecordCopyWith<$R, StudySessionStepRecord, $Out> {
  _StudySessionStepRecordCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<StudySessionStepRecord> $mapper =
      StudySessionStepRecordMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? sessionId,
          String? stepId,
          String? studyCardId,
          int? sequenceNumber,
          int? attemptNumber,
          String? userAnswer,
          StudyRating? rating,
          DateTime? enteredAt,
          DateTime? completedAt,
          Object? drillAnswerId = $none,
          Object? fsrsReviewLogId = $none}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (sessionId != null) #sessionId: sessionId,
        if (stepId != null) #stepId: stepId,
        if (studyCardId != null) #studyCardId: studyCardId,
        if (sequenceNumber != null) #sequenceNumber: sequenceNumber,
        if (attemptNumber != null) #attemptNumber: attemptNumber,
        if (userAnswer != null) #userAnswer: userAnswer,
        if (rating != null) #rating: rating,
        if (enteredAt != null) #enteredAt: enteredAt,
        if (completedAt != null) #completedAt: completedAt,
        if (drillAnswerId != $none) #drillAnswerId: drillAnswerId,
        if (fsrsReviewLogId != $none) #fsrsReviewLogId: fsrsReviewLogId
      }));
  @override
  StudySessionStepRecord $make(CopyWithData data) => StudySessionStepRecord(
      id: data.get(#id, or: $value.id),
      sessionId: data.get(#sessionId, or: $value.sessionId),
      stepId: data.get(#stepId, or: $value.stepId),
      studyCardId: data.get(#studyCardId, or: $value.studyCardId),
      sequenceNumber: data.get(#sequenceNumber, or: $value.sequenceNumber),
      attemptNumber: data.get(#attemptNumber, or: $value.attemptNumber),
      userAnswer: data.get(#userAnswer, or: $value.userAnswer),
      rating: data.get(#rating, or: $value.rating),
      enteredAt: data.get(#enteredAt, or: $value.enteredAt),
      completedAt: data.get(#completedAt, or: $value.completedAt),
      drillAnswerId: data.get(#drillAnswerId, or: $value.drillAnswerId),
      fsrsReviewLogId: data.get(#fsrsReviewLogId, or: $value.fsrsReviewLogId));

  @override
  StudySessionStepRecordCopyWith<$R2, StudySessionStepRecord, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _StudySessionStepRecordCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
