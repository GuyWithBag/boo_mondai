// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/drill_session_page_controller.dart
// PURPOSE: Orchestrates an active drill session using the new architecture
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        ReviewCard,
        DrillSession,
        StudySessionController,
        DrillAnswer,
        SessionException,
        StudyRating,
        LocalDB,
        DrillService,
        uuid,
        FsrsCard,
        Services,
        StudySessionService;
import 'package:flutter/material.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

class DrillSessionController
    extends StudySessionController<ReviewCard, DrillSession> {
  static const int defaultBatchSize = 20;

  final List<DrillAnswer> _currentAnswers = [];

  bool _isComplete = false;

  final Map<String, int> _strikes = {};

  @override
  bool get isComplete => _isComplete;

  @override
  ReviewCard? get currentReviewCard =>
      queue.isNotEmpty && currentIndex < queue.length
      ? queue[currentIndex]
      : null;

  List<DrillAnswer> get answers => List.unmodifiable(_currentAnswers);

  bool get lastAnswerWrong {
    if (_currentAnswers.isEmpty) return false;
    final lastType = _currentAnswers.last.type;
    return lastType == StudyRating.incorrect || lastType == StudyRating.again;
  }

  int get correctCount {
    return _currentAnswers.where((a) {
      return a.type != StudyRating.incorrect && a.type != StudyRating.again;
    }).length;
  }

  // ── Session Lifecycle ──
  void startSession(
    String deckId, {
    bool previewed = false,
    int? batchSize,
    bool realTime = false,
  }) {
    setError(null);
    _currentAnswers.clear();
    realTimeSaving = realTime; // Set the toggle

    try {
      final userId = LocalDB.profile.getOrCreate().id;

      final allTemplates = LocalDB.cardTemplate.getByDeckId(deckId);
      templates = {for (final t in allTemplates) t.id: t};

      final allReviewCards = LocalDB.reviewCard.getByDeckId(deckId);
      final eligibleCards = DrillService.getEligibleDrillCards(deckId, userId);

      if (eligibleCards.isEmpty) {
        throw SessionException(
          allReviewCards.isEmpty
              ? 'No reviewable cards found in this deck.'
              : 'You have already drillzed all the cards in this deck! Head to FSRS Reviews to practice them.',
          code: 'DRILL_NO_ELIGIBLE_CARDS',
        );
      }

      final limit = batchSize ?? defaultBatchSize;
      final batch = (eligibleCards..shuffle()).take(limit).toList();
      session = DrillSession(
        id: uuid.v7(),
        userId: userId,
        deckId: deckId,
        previewed: previewed,
        totalQuestions: batch.length,
        correctCount: 0,
        startedAt: DateTime.now(),
      );

      queue = batch;
      currentIndex = 0;
      _strikes.clear();
      nextIntervals.clear();
      _isComplete = false;
    } on SessionException catch (e) {
      setError(e);
    } on Exception catch (e, stackTrace) {
      setError(
        SessionException(
          'Failed to start drill session: $e',
          code: 'DRILL_INIT_FAILED',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  void _createStrike(ReviewCard reviewCard) {
    _strikes[reviewCard.id] = (_strikes[reviewCard.id] ?? 0) + 1;
  }

  @override
  Future<void> submitAnswer(String userAnswer, StudyRating type) async {
    final reviewCard = currentReviewCard;
    if (reviewCard == null) {
      failSession(
        'Cannot submit a drill answer without a current review card.',
        code: 'DRILL_CARD_MISSING',
      );
    }
    if (session == null) {
      failSession(
        'Cannot submit a drill answer before the session has started.',
        code: 'DRILL_SESSION_MISSING',
      );
    }

    _createStrike(reviewCard);

    final newAnswer = DrillAnswer.create(
      sessionId: session!.id,
      cardId: reviewCard.id,
      userAnswer: userAnswer,
      type: type,
    );

    _currentAnswers.add(newAnswer);

    // ── THE TOGGLE (REAL-TIME) ──
    if (realTimeSaving) {
      await LocalDB.drillAnswer.upsert(newAnswer);

      session = session!.copyWith(correctCount: correctCount);
      await LocalDB.drillSession.upsert(session!);

      // Real-time FSRS enrollment for correct answers
      if (type != StudyRating.incorrect) {
        // SAFETY CHECK: Ensure it isn't already enrolled
        final existing = LocalDB.fsrsCard.getByReviewCardId(reviewCard.id);

        if (existing == null) {
          final fsrsCard = await FsrsCard.create(
            reviewCardId: reviewCard.id,
            userId: session!.userId,
          );
          // Make sure to await this so the Hive box finishes writing!
          await Services.fsrs.enrollCard(
            card: fsrsCard,
            rating: StudySessionService.studyRatingToFSRSRating(type),
          );
        }
      }
    }

    if (type == StudyRating.incorrect) {
      queue.add(reviewCard);
      session = session!.copyWith(totalQuestions: queue.length);
    }

    currentIndex++;
    nextIntervals.clear();

    if (currentIndex >= queue.length) {
      await completeSession();
    } else {
      notifyListeners();
    }
  }

  @override
  Future<void> calculateNextIntervals() async {
    // Generate a brand new default state for an un-enrolled card
    final newFsrsState = await fsrs.Card.create();

    nextIntervals.clear();
    nextIntervals = StudySessionService.generateIntervalsForState(newFsrsState);
  }

  @override
  @protected
  Future<void> completeSession() async {
    if (session == null) {
      failSession(
        'Cannot complete a drill session before it has started.',
        code: 'DRILL_SESSION_MISSING',
      );
    }

    try {
      session = session!.copyWith(
        completedAt: DateTime.now(),
        correctCount: correctCount,
        totalQuestions: queue.length,
      );
      _isComplete = true;

      if (realTimeSaving) {
        await LocalDB.drillSession.upsert(session!);
      } else {
        // ── BATCH SAVE ──
        await LocalDB.drillSession.upsert(session!);
        await LocalDB.drillAnswer.upsertMany(_currentAnswers);

        // 1. Deduplicate: Get only the final correct answer for each card
        final eligibleAnswersMap = <String, DrillAnswer>{};
        for (final a in _currentAnswers) {
          if (a.type != StudyRating.incorrect) {
            eligibleAnswersMap[a.cardId] = a;
          }
        }

        // 2. Process enrollments safely
        for (final answer in eligibleAnswersMap.values) {
          // SAFETY CHECK: Ensure it isn't already enrolled
          final existing = LocalDB.fsrsCard.getByReviewCardId(answer.cardId);
          if (existing != null) continue;

          final fsrsCard = await FsrsCard.create(
            reviewCardId: answer.cardId,
            userId: session!.userId,
          );

          await Services.fsrs.enrollCard(
            card: fsrsCard,
            rating: StudySessionService.studyRatingToFSRSRating(answer.type),
          );
        }
      }
      notifyListeners();
    } on SessionException catch (e) {
      setError(e);
    } on Exception catch (e, stackTrace) {
      setError(
        SessionException(
          'Failed to complete drill session: $e',
          code: 'DRILL_COMPLETE_FAILED',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  void reset() {
    session = null;
    queue = [];
    templates.clear();
    _currentAnswers.clear();
    currentIndex = 0;
    _strikes.clear();
    nextIntervals.clear();
    _isComplete = false;
    setError(null);
    notifyListeners();
  }
}
