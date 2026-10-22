
import 'package:boo_mondai/lib.barrel.dart' show StudySessionSnapshot, HiveLocalDB, HivePrimaryKey;

final class StudySessionSnapshotsLocalDB
    extends HiveLocalDB<StudySessionSnapshot> {
  @override
  String get boxName => 'study_session_snapshots';

  @override
  HivePrimaryKey primaryKeyFromItem(StudySessionSnapshot item) => {
    'session_id': item.sessionId,
    'step_id': item.step.id,
  };

  List<StudySessionSnapshot> getBySessionId(String sessionId) =>
      selectMany(where: (item) => item.sessionId == sessionId);
}
