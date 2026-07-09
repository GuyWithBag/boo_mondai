import 'package:boo_mondai/features/study_session/models/session_flow_snapshot.dto.dart';
import 'package:boo_mondai/features/study_session/models/study_session_step_record.dto.dart';
import 'package:boo_mondai/features/study_session/persistence/study_session_flows.local.db.dart';
import 'package:boo_mondai/features/study_session/persistence/study_session_step_records.local.db.dart';

final class StudySessionLocalStore {
  const StudySessionLocalStore({
    required StudySessionFlowsLocalDB flows,
    required StudySessionStepRecordsLocalDB records,
  }) : _flows = flows,
       _records = records;

  final StudySessionFlowsLocalDB _flows;
  final StudySessionStepRecordsLocalDB _records;

  SessionFlowSnapshot? loadFlow(String sessionId) {
    return _flows.getBySessionId(sessionId);
  }

  Future<void> saveFlow(SessionFlowSnapshot snapshot) {
    return _flows.upsert(snapshot);
  }

  StudySessionStepRecord? loadRecord(String sessionId, String stepId) {
    return _records.getByStepId(sessionId, stepId);
  }

  List<StudySessionStepRecord> loadRecords(String sessionId) {
    return _records.getBySessionId(sessionId);
  }

  Future<void> saveRecord(StudySessionStepRecord record) {
    return _records.upsert(record);
  }

  Future<void> deleteSession(String sessionId) async {
    await _flows.deleteByPk({'session_id': sessionId});
    final records = _records.getBySessionId(sessionId);
    await _records.deleteManyByPk([
      for (final record in records)
        {'session_id': record.sessionId, 'step_id': record.stepId},
    ]);
  }
}
