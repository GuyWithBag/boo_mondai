import 'package:boo_mondai/core/database/hive.local.db.dart';
import 'package:boo_mondai/features/study_session/models/session_flow_snapshot.dto.dart';

final class StudySessionFlowsLocalDB extends HiveLocalDB<SessionFlowSnapshot> {
  @override
  String get boxName => 'study_session_flows_v1';

  @override
  Map<String, Object?> primaryKeyFromItem(SessionFlowSnapshot item) => {
    'session_id': item.sessionId,
  };

  SessionFlowSnapshot? getBySessionId(String sessionId) {
    return selectByPk({'session_id': sessionId});
  }
}
