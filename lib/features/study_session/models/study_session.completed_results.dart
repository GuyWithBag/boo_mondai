import 'package:boo_mondai/lib.barrel.dart'
    show FsrsCard, FsrsReviewLog, SessionMode, StudySessionSnapshot;

final class StudySessionCompletedResults {
  const StudySessionCompletedResults({
    required this.profileId,
    required this.sessionId,
    required this.deckId,
    required this.mode,
    required this.startedAt,
    required this.snapshots,
    required this.fsrsCards,
    required this.fsrsLogs,
    required this.correctCount,
    required this.cardCount,
  });

  final String profileId;
  final String sessionId;
  final String? deckId;
  final SessionMode mode;
  final DateTime startedAt;
  final List<StudySessionSnapshot> snapshots;
  final List<FsrsCard> fsrsCards;
  final List<FsrsReviewLog> fsrsLogs;
  final int correctCount;
  final int cardCount;
}
