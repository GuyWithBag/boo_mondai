import 'package:boo_mondai/lib.barrel.dart'
    show HiveLocalDB, HivePrimaryKey, StudySessionCompletedResults;

final class StudySessionCompletedResultsLocalDB
    extends HiveLocalDB<StudySessionCompletedResults> {
  @override
  String get boxName => 'study_session_completed_results';

  @override
  HivePrimaryKey primaryKeyFromItem(StudySessionCompletedResults item) => {
    'session_id': item.sessionId,
  };

  StudySessionCompletedResults? getBySessionId(String sessionId) =>
      selectByPk({'session_id': sessionId});

  List<StudySessionCompletedResults> getByProfileId(String profileId) =>
      selectMany(where: (item) => item.profileId == profileId);

  List<StudySessionCompletedResults> getByDeckId(String deckId) =>
      selectMany(where: (item) => item.deckId == deckId);
}
