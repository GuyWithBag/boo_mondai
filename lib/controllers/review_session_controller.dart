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
    sessionError = null;
    dueFilter = filter;
    _queue.clear();
    _pendingCards.clear();
    _pendingLogs.clear();
    currentIndex = 0;
    realTimeSaving = realTime;

    notifyListeners();

    try {
      final userId = LocalIdentityService.getOrCreate();
      final now = DateTime.now();

      final allFsrsCards = Repositories.fsrsCard.getByUserId(userId);
      final allReviewCards = Repositories.reviewCard.getAll();

      // Fetch and populate templates
      final allTemplates = Repositories.cardTemplate.getAll();
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
      sessionError = 'Failed to load session data: $e';
    } finally {
      notifyListeners();
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
      cardId: fsrsCard.id,
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
      await Repositories.fsrsCard.save(updatedCard);
      await Repositories.reviewLog.save(log);
      await Repositories.reviewSession.save(_session!); // Assumes repo exists
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
        // Just save the final session state
        await Repositories.reviewSession.save(_session!);
      } else {
        // Batch Save everything
        if (_pendingCards.isNotEmpty) {
          await Repositories.fsrsCard.saveAll(_pendingCards.values.toList());
        }
        if (_pendingLogs.isNotEmpty) {
          await Repositories.reviewLog.saveAll(_pendingLogs);
        }
        await Repositories.reviewSession.save(_session!);
      }
    } catch (e) {
      sessionError = e.toString();
    } finally {
      notifyListeners();
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
