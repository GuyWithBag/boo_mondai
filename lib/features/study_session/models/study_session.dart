import 'package:boo_mondai/lib.barrel.dart'
    show
        SessionException,
        StudySessionCardStep,
        SessionMode,
        StudySessionStep,
        StudySessionSnapshot,
        StudySessionCompletedResults,
        FsrsCard,
        FsrsReviewLog,
        StudyRating;

/// Pure, immutable snapshot of a study session's state.
///
/// This class holds no reactive state (no `Signal`s) and has no
/// mutation logic of its own — it is data only. State transitions
/// (validating and applying a step) live in [StudySessionController],
/// which owns the reactive layer and produces new [StudySession]
/// values via [copyWith].
final class StudySession {
  StudySession({
    required this.id,
    required this.profileId,
    required this.deckId,
    required this.mode,
    required this.startedAt,
    required this.steps,
    this.currentIndex = 0,
    this.history = const [],
    this.isSaved = false,
  }) {
    if (steps.isEmpty) {
      throw SessionException(
        'No cards available for this session.',
        code: 'SESSION_EMPTY',
      );
    }
    final ids = steps.map((step) => step.id).toSet();
    if (ids.length != steps.length) {
      throw SessionException(
        'Duplicate session step.',
        code: 'SESSION_DUPLICATE_STEP',
      );
    }
  }

  final String id;
  final String profileId;
  final String? deckId;
  final SessionMode mode;
  final DateTime startedAt;
  final List<StudySessionStep> steps;
  final int currentIndex;
  final List<StudySessionSnapshot> history;
  final bool isSaved;

  StudySessionStep? get currentStep =>
      currentIndex < steps.length ? steps[currentIndex] : null;

  bool get isFinished => currentStep == null;

  StudySessionCompletedResults get completedResults {
    var cardCount = 0;
    final fsrsCards = <String, FsrsCard>{};
    final fsrsLogs = <FsrsReviewLog>[];
    var correctCount = 0;
    for (final snapshot in history) {
      final step = snapshot.step;
      if (step is! StudySessionCardStep) continue;
      cardCount++;
      final rating = snapshot.rating!;
      if (rating != StudyRating.incorrect && rating != StudyRating.again) {
        correctCount++;
      }
      final updated = snapshot.fsrsCardAfter;
      if (updated != null) fsrsCards[updated.studyCardId] = updated;
      final log = snapshot.fsrsReviewLog;
      if (log != null) fsrsLogs.add(log);
    }
    return StudySessionCompletedResults(
      profileId: profileId,
      sessionId: id,
      deckId: deckId,
      mode: mode,
      startedAt: startedAt,
      snapshots: history,
      fsrsCards: List.unmodifiable(fsrsCards.values),
      fsrsLogs: List.unmodifiable(fsrsLogs),
      correctCount: correctCount,
      cardCount: cardCount,
    );
  }

  StudySession copyWith({
    List<StudySessionStep>? steps,
    int? currentIndex,
    List<StudySessionSnapshot>? history,
    bool? isSaved,
  }) {
    return StudySession(
      id: id,
      profileId: profileId,
      deckId: deckId,
      mode: mode,
      startedAt: startedAt,
      steps: steps ?? this.steps,
      currentIndex: currentIndex ?? this.currentIndex,
      history: history ?? this.history,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
