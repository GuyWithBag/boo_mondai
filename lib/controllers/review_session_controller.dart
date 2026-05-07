// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/review_session_controller.dart
// PURPOSE: Orchestrates an interactive FSRS review session
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

class ReviewSessionController extends StudySessionController {
  // ── Specific State ──
  ReviewSession? _session;
  final List<FsrsCard> _queue = [];
  final Map<String, ReviewCard> _reviewCards = {};
  late DueFilterThreshold dueFilter;

  // ── BATCH SAVING STATE ──
  final List<FsrsReviewLog> _pendingLogs = [];
  final Map<String, FsrsCard> _pendingCards = {};

  // ── Specific Getters ──
  ReviewSession? get session => _session;

  int get remainingCount =>
      (_queue.length - currentIndex).clamp(0, _queue.length);

  @override
  bool get isComplete => _queue.isEmpty || currentIndex >= _queue.length;

  @override
  double get progress =>
      _queue.isEmpty ? 0 : (currentIndex / _queue.length).clamp(0.0, 1.0);

  FsrsCard? get currentFsrsCard =>
      (_queue.isNotEmpty && currentIndex < _queue.length)
      ? _queue[currentIndex]
      : null;

  @override
  ReviewCard? get currentReviewCard => currentFsrsCard != null
      ? _reviewCards[currentFsrsCard!.reviewCardId]
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
    _queue.clear();
    _pendingCards.clear();
    _pendingLogs.clear();
    currentIndex = 0;
    realTimeSaving = realTime;

    notifyListeners();

    try {
      final userId = LocalDB.profile.getOrCreate().userId;
      final now = DateTime.now();

      final allFsrsCards = LocalDB.fsrsCard.getByUserId(userId);
      final allReviewCards = LocalDB.reviewCard.getAll();

      // Fetch and populate templates
      final allTemplates = LocalDB.cardTemplate.getAll();
      for (final t in allTemplates) {
        templates[t.id] = t;
      }

      final rcToDeck = {for (final rc in allReviewCards) rc.id: rc.deckId};

      // Populate review cards map
      for (final rc in allReviewCards) {
        _reviewCards[rc.id] = rc;
      }

      var targetCards = allFsrsCards;
      if (deckId != null) {
        targetCards = targetCards.where((c) {
          return rcToDeck[c.reviewCardId] == deckId;
        }).toList();
      }

      var dueCards = targetCards.where((c) {
        return filter.isCardDue(c.state.due, now);
      }).toList();

      dueCards.shuffle();
      _queue.addAll(dueCards);

      // ── NEW: Initialize the ReviewSession ──
      _session = ReviewSession(
        id: UuidService.uuid.v4(),
        userId: userId,
        deckId: deckId,
        totalCards: _queue.length,
        startedAt: now,
      );
    } catch (e) {
      setError(
        SessionException(
          'Failed to load session data: $e',
          code: 'SESSION_INIT_FAILED',
        ),
      );
    }
  }

  @override
  Future<void> calculateNextIntervals() async {
    final currentFsrs = currentFsrsCard;
    if (currentFsrs == null) return;

    // Pass the existing card's memory state
    generateIntervalsForState(currentFsrs.state);
  }

  // ── The Single Submit Logic ──
  @override
  Future<void> submitAnswer(String userAnswer, StudyRating rating) async {
    final fsrsCard = currentFsrsCard;
    if (fsrsCard == null || _session == null) return;

    final fsrsRating = mapToFsrsRating(rating);
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
      id: UuidService.uuid.v4(),
      createdAt: DateTime.now(),
      fsrsCardId: fsrsCard.id,
      log: result.reviewLog,
    );

    // Append to queue if they forgot it (FSRS requires re-reviewing)
    if (dueFilter.isCardDue(updatedCard.state.due, now)) {
      _queue.add(updatedCard);
    }

    // ── NEW: Update session progress ──
    // Note: If cards get added back to the queue, totalCards updates so progress bars stay accurate
    _session = _session!.copyWith(
      cardsReviewed: _session!.cardsReviewed + 1,
      totalCards: _queue.length,
    );

    // ── THE TOGGLE ──
    if (realTimeSaving) {
      await LocalDB.fsrsCard.put(updatedCard);
      await LocalDB.reviewLog.put(log);
      await LocalDB.reviewSession.put(_session!); // Assumes repo exists
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
  Future<void> completeSession() async {
    if (_session == null) return;

    try {
      // ── NEW: Finalize session ──
      _session = _session!.copyWith(completedAt: DateTime.now());

      if (realTimeSaving) {
        // Just put the final session state
        await LocalDB.reviewSession.put(_session!);
      } else {
        // Batch Save everything
        if (_pendingCards.isNotEmpty) {
          await LocalDB.fsrsCard.putAll(_pendingCards.values.toList());
        }
        if (_pendingLogs.isNotEmpty) {
          await LocalDB.reviewLog.putAll(_pendingLogs);
        }
        await LocalDB.reviewSession.put(_session!);
      }
    } on Exception catch (e) {
      setError(
        SessionException(
          'Failed to save session data: $e',
          code: 'SESSION_COMPLETE_FAILED',
        ),
      );
    }
  }

  @override
  void reset() {
    _session = null;
    _queue.clear();
    _pendingLogs.clear();
    _pendingCards.clear();
    currentIndex = 0;
    notifyListeners();
  }
}
