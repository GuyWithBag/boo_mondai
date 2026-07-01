// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/review_session_controller.dart
// PURPOSE: Orchestrates an interactive FSRS review session
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';
import 'package:flutter/cupertino.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

class ReviewSessionController
    extends StudySessionController<FsrsCard, ReviewSession> {
  // ── Specific State ──
  final Map<String, StudyCard> _studyCards = {};
  late DueFilterThreshold dueFilter;

  // ── BATCH SAVING STATE ──
  final List<FsrsReviewLog> _pendingLogs = [];
  final Map<String, FsrsCard> _pendingCards = {};

  int get remainingCount =>
      (queue.length - currentIndex).clamp(0, queue.length);

  @override
  bool get isComplete => queue.isEmpty || currentIndex >= queue.length;

  FsrsCard? get currentFsrsCard =>
      (queue.isNotEmpty && currentIndex < queue.length)
      ? queue[currentIndex]
      : null;

  @override
  StudyCard? get currentStudyCard => currentFsrsCard != null
      ? _studyCards[currentFsrsCard!.studyCardId]
      : null;

  // ── Initialization ──
  void startSession({
    String? deckId,
    bool realTime = false,
    required DueFilterThreshold filter,
  }) {
    // 1. Reset session state
    setError(null);
    dueFilter = filter;
    session = null;
    queue.clear();
    templates.clear();
    _studyCards.clear();
    _pendingCards.clear();
    _pendingLogs.clear();
    nextIntervals.clear();
    currentIndex = 0;
    realTimeSaving = realTime;

    notifyListeners();

    try {
      final userId = LocalDB.profile.getOrCreate().id;
      final now = DateTime.now();

      final allFsrsCards = LocalDB.fsrsCard.getByUserId(userId);
      final allStudyCards = LocalDB.studyCard.selectMany();

      // Fetch and populate templates
      final allTemplates = LocalDB.cardTemplate.selectMany();
      for (final t in allTemplates) {
        templates[t.id] = t;
      }

      final rcToDeck = {for (final rc in allStudyCards) rc.id: rc.deckId};

      // Populate review cards map
      for (final rc in allStudyCards) {
        _studyCards[rc.id] = rc;
      }

      var targetCards = allFsrsCards;
      if (deckId != null) {
        targetCards = targetCards.where((c) {
          return rcToDeck[c.studyCardId] == deckId;
        }).toList();
      }

      var dueCards = targetCards.where((c) {
        return filter.isCardDue(c.state.due, now);
      }).toList();

      dueCards.shuffle();
      queue.addAll(dueCards);

      // ── NEW: Initialize the ReviewSession ──
      session = ReviewSession(
        id: uuid.v7(),
        userId: userId,
        deckId: deckId,
        totalCards: queue.length,
        startedAt: now,
      );
    } on SessionException catch (e) {
      setError(e);
    } catch (e, stackTrace) {
      setError(
        SessionException(
          'Failed to load session data: $e',
          code: 'SESSION_INIT_FAILED',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<void> calculateNextIntervals() async {
    final currentFsrs = currentFsrsCard;
    if (currentFsrs == null) {
      failSession(
        'Cannot calculate review intervals without a current FSRS card.',
        code: 'REVIEW_CARD_MISSING',
      );
    }

    // Pass the existing card's memory state
    nextIntervals.clear();
    nextIntervals = StudySessionService.generateIntervalsForState(
      currentFsrs.state,
    );
    notifyListeners();
  }

  // ── The Single Submit Logic ──
  @override
  Future<void> submitAnswer(String userAnswer, StudyRating rating) async {
    final fsrsCard = currentFsrsCard;
    if (fsrsCard == null) {
      failSession(
        'Cannot submit a review answer without a current FSRS card.',
        code: 'REVIEW_CARD_MISSING',
      );
    }
    if (session == null) {
      failSession(
        'Cannot submit a review answer before the session has started.',
        code: 'REVIEW_SESSION_MISSING',
      );
    }

    final fsrsRating = StudySessionService.studyRatingToFSRSRating(rating);
    final now = DateTime.now();

    // The time travel trick for future look-ahead reviews
    DateTime? customReviewTime;
    if (fsrsCard.state.due.isAfter(now)) {
      customReviewTime = fsrsCard.state.due;
    }

    final scheduler = fsrs.Scheduler();
    final utcReviewTime = customReviewTime?.toUtc() ?? now.toUtc();
    final result = scheduler.reviewCard(
      fsrsCard.state,
      fsrsRating,
      reviewDateTime: utcReviewTime,
    );

    final updatedCard = fsrsCard.copyWith(state: result.card);

    final log = FsrsReviewLog(
      id: uuid.v7(),
      createdAt: DateTime.now(),
      fsrsCardId: fsrsCard.id,
      log: result.reviewLog,
    );

    // Requeue failed answers for another pass in the same session.
    if (rating == StudyRating.incorrect || rating == StudyRating.again) {
      queue.add(updatedCard);
    }

    // ── NEW: Update session progress ──
    // Note: If cards get added back to the queue, totalCards updates so progress bars stay accurate
    session = session!.copyWith(
      cardsReviewed: session!.cardsReviewed + 1,
      totalCards: queue.length,
    );

    // ── THE TOGGLE ──
    if (realTimeSaving) {
      await LocalDB.fsrsCard.upsert(updatedCard);
      await LocalDB.reviewLog.upsert(log);
      await Services.streak.refreshFromReviewLogs();
      await LocalDB.reviewSession.upsert(session!); // Assumes repo exists
    } else {
      _pendingCards[updatedCard.id] = updatedCard;
      _pendingLogs.add(log);
    }

    currentIndex++;
    nextIntervals.clear();

    if (isComplete) {
      await completeSession();
    } else {
      notifyListeners();
    }
  }

  // ── Session Completion ──
  @override
  @protected
  Future<void> completeSession() async {
    if (session == null) {
      failSession(
        'Cannot complete a review session before it has started.',
        code: 'REVIEW_SESSION_MISSING',
      );
    }

    try {
      // ── NEW: Finalize session ──
      session = session!.copyWith(completedAt: DateTime.now());

      if (realTimeSaving) {
        // Just put the final session state
        await LocalDB.reviewSession.upsert(session!);
      } else {
        // Batch Save everything
        if (_pendingCards.isNotEmpty) {
          await LocalDB.fsrsCard.upsertMany(_pendingCards.values.toList());
        }
        if (_pendingLogs.isNotEmpty) {
          await LocalDB.reviewLog.upsertMany(_pendingLogs);
        }
        await Services.streak.refreshFromReviewLogs();
        await LocalDB.reviewSession.upsert(session!);
      }
      notifyListeners();
    } on SessionException catch (e) {
      setError(e);
    } on Exception catch (e, stackTrace) {
      setError(
        SessionException(
          'Failed to save session data: $e',
          code: 'SESSION_COMPLETE_FAILED',
          originalError: e,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  void reset() {
    session = null;
    queue.clear();
    _pendingLogs.clear();
    _pendingCards.clear();
    _studyCards.clear();
    templates.clear();
    nextIntervals.clear();
    currentIndex = 0;
    setError(null);
    notifyListeners();
  }
}
