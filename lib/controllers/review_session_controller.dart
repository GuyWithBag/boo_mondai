// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/review_session_controller.dart
// PURPOSE: Orchestrates an interactive FSRS review session
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

class ReviewSessionController extends SessionController {
  // ── Specific State ──
  List<FsrsCard> _queue = [];
  Map<String, ReviewCard> _reviewCards = {};
  bool _isLoading = false;

  // ── BATCH SAVING STATE ──
  final List<FsrsReviewLog> _pendingLogs = [];
  final Map<String, FsrsCard> _pendingCards = {};

  // ── Specific Getters ──
  bool get isLoading => _isLoading;
  int get remainingCount =>
      (_queue.length - currentIndex).clamp(0, _queue.length);

  FsrsCard? get currentFsrsCard => !isComplete ? _queue[currentIndex] : null;

  @override
  bool get isComplete => _queue.isNotEmpty && currentIndex >= _queue.length;

  @override
  ReviewCard? get currentReviewCard => currentFsrsCard != null
      ? _reviewCards[currentFsrsCard!.reviewCardId]
      : null;

  // ── Initialization ──
  Future<void> startSession({String? deckId, bool realTime = false}) async {
    _isLoading = true;
    sessionError = null;
    currentIndex = 0;
    _queue.clear();
    _pendingLogs.clear();
    _pendingCards.clear();
    realTimeSaving = realTime;
    notifyListeners();

    try {
      final userId = Services.auth.currentUser!.id;
      final now = DateTime.now();

      final allFsrsCards = Repositories.fsrsCard.getByUserId(userId);
      var dueCards = allFsrsCards.where((c) {
        return c.state.due.isBefore(now) || c.state.due.isAtSameMomentAs(now);
      }).toList();

      final allReviewCards = Repositories.reviewCard.getAll();
      final allTemplates = Repositories.cardTemplate.getAll();

      _reviewCards = {for (final rc in allReviewCards) rc.id: rc};
      templates = {for (final t in allTemplates) t.id: t};

      if (deckId != null) {
        dueCards = dueCards
            .where((c) => _reviewCards[c.reviewCardId]?.deckId == deckId)
            .toList();
      }

      _queue = dueCards..shuffle();

      if (_queue.isEmpty) {
        throw Exception('No cards due right now! You are all caught up.');
      }
    } catch (e) {
      sessionError = e.toString().replaceAll('Exception: ', '');
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
    final scheduler = fsrs.Scheduler();
    final result = scheduler.reviewCard(fsrsCard.state, fsrsRating);

    final updatedCard = fsrsCard.copyWith(state: result.card);

    final log = FsrsReviewLog(
      id: UuidService.uuid.v4(),
      cardId: fsrsCard.id,
      log: result.reviewLog,
    );

    // ── THE TOGGLE ──
    if (realTimeSaving) {
      await Repositories.fsrsCard.save(updatedCard);
      await Repositories.reviewLog.save(log);
    } else {
      _pendingCards[updatedCard.id] = updatedCard;
      _pendingLogs.add(log);
    }

    // Append to queue if they forgot it
    if (fsrsRating == fsrs.Rating.again) {
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
