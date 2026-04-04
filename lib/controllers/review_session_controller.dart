// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/review_session_controller.dart
// PURPOSE: Orchestrates an interactive FSRS review session
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

class ReviewSessionController extends SessionController {
  // ── Specific State ──
  final List<FsrsCard> _queue = [];
  final Map<String, ReviewCard> _reviewCards = {};
  bool _isLoading = false;
  late DueFilterThreshold dueFilter;

  // ── BATCH SAVING STATE ──
  final List<FsrsReviewLog> _pendingLogs = [];
  final Map<String, FsrsCard> _pendingCards = {};

  // ── Specific Getters ──
  bool get isLoading => _isLoading;

  int get remainingCount =>
      (_queue.length - currentIndex).clamp(0, _queue.length);

  @override
  bool get isComplete => _queue.isEmpty || currentIndex >= _queue.length;

  FsrsCard? get currentFsrsCard =>
      (_queue.isNotEmpty && currentIndex < _queue.length)
      ? _queue[currentIndex]
      : null;

  @override
  ReviewCard? get currentReviewCard => currentFsrsCard != null
      ? _reviewCards[currentFsrsCard!.reviewCardId]
      : null;

  // ── Initialization ──
  Future<void> startSession({
    String? deckId,
    bool realTime = false,
    required DueFilterThreshold filter,
  }) async {
    // 1. Reset session state
    _isLoading = true;
    sessionError = null; // 👈 Using the base class variable!
    dueFilter = filter;
    _queue.clear();
    _pendingCards.clear();
    _pendingLogs.clear();
    currentIndex = 0;
    realTimeSaving = realTime;

    notifyListeners();

    try {
      final userId = Services.auth.currentUser!.id;
      final now = DateTime.now();

      final allFsrsCards = Repositories.fsrsCard.getByUserId(userId);
      final allReviewCards = Repositories.reviewCard.getAll();

      // ── THE FIX: Fetch and populate templates ──
      // (Adjust 'cardTemplate' if your repository is named slightly differently)
      final allTemplates = Repositories.cardTemplate.getAll();
      for (final t in allTemplates) {
        templates[t.id] = t; // 'templates' is inherited from SessionController
      }
      // ──────────────────────────────────────────

      final rcToDeck = {for (final rc in allReviewCards) rc.id: rc.deckId};

      // Ensure we populate the _reviewCards map so `currentReviewCard` works
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
    } catch (e) {
      sessionError =
          'Failed to load session data: $e'; // 👈 Using the base class variable!
    } finally {
      _isLoading = false;
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

  // ── The Single Submit Logic (Triggered by RatingArea) ──
  @override
  Future<void> submitAnswer(String userAnswer, QuizAnswerType type) async {
    final fsrsCard = currentFsrsCard;
    if (fsrsCard == null) return;

    final fsrsRating = mapToFsrsRating(type);
    final now = DateTime.now();

    // ── THE TIME TRAVEL TRICK ──
    // If the card is due in the future (Look-ahead), pretend we are answering
    // it exactly when it is due so FSRS doesn't penalize the interval.
    DateTime? customReviewTime;
    if (fsrsCard.state.due.isAfter(now)) {
      customReviewTime = fsrsCard.state.due;
    }

    // Process the card using your updated FsrsService
    // (Assuming you instantiate FsrsService or have it as a singleton somewhere,
    // e.g., `Services.fsrs.enrollCard` or similar based on your architecture)

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

    // ── THE TOGGLE (Unchanged) ──
    if (realTimeSaving) {
      await Repositories.fsrsCard.save(updatedCard);
      await Repositories.reviewLog.save(log);
    } else {
      _pendingCards[updatedCard.id] = updatedCard;
      _pendingLogs.add(log);
    }

    // Append to queue if they forgot it
    if (dueFilter.isCardDue(updatedCard.state.due, now)) {
      _queue.add(updatedCard);
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
    try {
      if (!realTimeSaving) {
        if (_pendingCards.isNotEmpty) {
          await Repositories.fsrsCard.saveAll(_pendingCards.values.toList());
        }
        if (_pendingLogs.isNotEmpty) {
          await Repositories.reviewLog.saveAll(_pendingLogs);
        }
      }
    } catch (e) {
      sessionError = e.toString();
    } finally {
      notifyListeners();
    }
  }

  @override
  void reset() {
    _queue.clear();
    _pendingLogs.clear();
    _pendingCards.clear();
    currentIndex = 0;
    notifyListeners();
  }
}
