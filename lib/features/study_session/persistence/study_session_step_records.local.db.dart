import 'package:boo_mondai/core/database/hive.local.db.dart';
import 'package:boo_mondai/features/study_session/models/study_session_step_record.dto.dart';

final class StudySessionStepRecordsLocalDB
    extends HiveLocalDB<StudySessionStepRecord> {
  @override
  String get boxName => 'study_session_step_records_v1';

  @override
  Map<String, Object?> primaryKeyFromItem(StudySessionStepRecord item) => {
    'session_id': item.sessionId,
    'step_id': item.stepId,
  };

  StudySessionStepRecord? getByStepId(String sessionId, String stepId) {
    return selectByPk({'session_id': sessionId, 'step_id': stepId});
  }

  List<StudySessionStepRecord> getBySessionId(String sessionId) {
    return selectMany(where: (record) => record.sessionId == sessionId)
      ..sort((a, b) => a.sequenceNumber.compareTo(b.sequenceNumber));
  }
}
