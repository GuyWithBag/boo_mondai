// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/quiz_session_page_controller.dart
// PURPOSE: Orchestrates an active quiz session using the new architecture
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

class QuizSessionPageController extends SessionController {
  static const int defaultBatchSize = 20;

  // ── Specific State ──
  QuizSession? _session;
  List<ReviewCard> _queue = [];
  final List<QuizAnswer> _currentAnswers = [];

  int _batchSize = defaultBatchSize;
  bool _isComplete = false;

  final Map<String, int> _strikes = {};

  // ── Specific Getters ──
  QuizSession? get session => _session;

  @override
  bool get isComplete => _isComplete;

  @override
  ReviewCard? get currentReviewCard =>
      _queue.isNotEmpty && currentIndex < _queue.length
      ? _queue[currentIndex]
      : null;

  @override
  double get progress =>
      _batchSize == 0 ? 0 : (currentIndex / _batchSize).clamp(0.0, 1.0);

  List<QuizAnswer> get answers => List.unmodifiable(_currentAnswers);

  bool get lastAnswerWrong {
    if (_currentAnswers.isEmpty) return false;
    final lastType = _currentAnswers.last.type;
    return lastType == QuizAnswerType.incorrect ||
        lastType == QuizAnswerType.again;
  }

  int get correctCount {
    return _currentAnswers.where((a) {
      return a.type != QuizAnswerType.incorrect &&
          a.type != QuizAnswerType.again;
    }).length;
  }

  // ── Session Lifecycle ──
  void startSession(
    String deckId, {
    bool previewed = false,
    int? batchSize,
    bool realTime = false,
  }) {
    sessionError = null;
    _currentAnswers.clear();
    realTimeSaving = realTime; // Set the toggle

    try {
      final userId = Services.auth.currentUser!.id;

      final allTemplates = Repositories.cardTemplate.getByDeckId(deckId);
      templates = {for (final t in allTemplates) t.id: t};

      final allReviewCards = Repositories.reviewCard.getByDeckId(deckId);
      final eligibleCards = QuizService.getEligibleQuizCards(deckId, userId);

      if (eligibleCards.isEmpty) {
        throw Exception(
          allReviewCards.isEmpty
              ? 'No reviewable cards found in this deck.'
              : 'You have already quizzed all the cards in this deck! Head to FSRS Reviews to practice them.',
        );
      }

      final limit = batchSize ?? defaultBatchSize;
      final batch = (eligibleCards..shuffle()).take(limit).toList();
      _batchSize = batch.length;

      _session = QuizSession(
        id: UuidService.uuid.v4(),
        userId: userId,
        deckId: deckId,
        previewed: previewed,
        totalQuestions: batch.length,
        correctCount: 0,
        startedAt: DateTime.now(),
      );

      _queue = batch;
      currentIndex = 0;
      _strikes.clear();
      nextIntervals.clear();
      _isComplete = false;
    } on Exception catch (e) {
      sessionError = e.toString().replaceAll('Exception: ', '');
    }
    notifyListeners();
  }

  @override
  Future<void> submitAnswer(String userAnswer, QuizAnswerType type) async {
    final reviewCard = currentReviewCard;
    if (reviewCard == null || _session == null) return;

    _strikes[reviewCard.id] = (_strikes[reviewCard.id] ?? 0) + 1;

    final newAnswer = QuizAnswer.create(
      sessionId: _session!.id,
      cardId: reviewCard.id,
      userAnswer: userAnswer,
      type: type,
    );

    _currentAnswers.add(newAnswer);

    // ── THE TOGGLE (REAL-TIME) ──
    if (realTimeSaving) {
      await Repositories.quizAnswer.save(newAnswer);

      _session = _session!.copyWith(correctCount: correctCount);
      await Repositories.quizSession.save(_session!);

      // Real-time FSRS enrollment for correct answers
      if (type != QuizAnswerType.incorrect) {
        // SAFETY CHECK: Ensure it isn't already enrolled
        final existing = Repositories.fsrsCard.getByReviewCardId(reviewCard.id);

        if (existing == null) {
          final fsrsCard = await FsrsCard.create(
            reviewCardId: reviewCard.id,
            userId: _session!.userId,
          );
          // Make sure to await this so the Hive box finishes writing!
          await Services.fsrs.enrollCard(
            card: fsrsCard,
            rating: mapToFsrsRating(type),
          );
        }
      }
    }

    if (type == QuizAnswerType.incorrect) {
      _queue.add(reviewCard);
    }

    currentIndex++;
    nextIntervals.clear();

    if (currentIndex >= _queue.length) {
      await completeSession();
    } else {
      notifyListeners();
    }
  }

  @override
  Future<void> calculateNextIntervals() async {
    // Generate a brand new default state for an un-enrolled card
    final newFsrsState = await fsrs.Card.create();

    generateIntervalsForState(newFsrsState);
  }

  @override
  Future<void> completeSession() async {
    if (_session == null) return;

    try {
      _session = _session!.copyWith(
        completedAt: DateTime.now(),
        correctCount: correctCount,
      );
      _isComplete = true;

      if (realTimeSaving) {
        await Repositories.quizSession.save(_session!);
      } else {
        // ── BATCH SAVE ──
        await Repositories.quizSession.save(_session!);
        await Repositories.quizAnswer.saveAll(_currentAnswers);

        // 1. Deduplicate: Get only the final correct answer for each card
        final eligibleAnswersMap = <String, QuizAnswer>{};
        for (final a in _currentAnswers) {
          if (a.type != QuizAnswerType.incorrect) {
            eligibleAnswersMap[a.cardId] = a;
          }
        }

        // 2. Process enrollments safely
        for (final answer in eligibleAnswersMap.values) {
          // SAFETY CHECK: Ensure it isn't already enrolled
          final existing = Repositories.fsrsCard.getByReviewCardId(
            answer.cardId,
          );
          if (existing != null) continue;

          final fsrsCard = await FsrsCard.create(
            reviewCardId: answer.cardId,
            userId: _session!.userId,
          );

          await Services.fsrs.enrollCard(
            card: fsrsCard,
            rating: mapToFsrsRating(answer.type),
          );
        }
      }
    } on Exception catch (e) {
      sessionError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  @override
  void reset() {
    _session = null;
    _queue = [];
    templates.clear();
    _currentAnswers.clear();
    currentIndex = 0;
    _strikes.clear();
    nextIntervals.clear();
    _batchSize = defaultBatchSize;
    _isComplete = false;
    sessionError = null;
    notifyListeners();
  }
}
