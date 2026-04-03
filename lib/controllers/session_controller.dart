// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/shared/interfaces/session_controller.dart
// PURPOSE: Abstract base class centralizing shared Quiz and FSRS logic
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/foundation.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

abstract class SessionController extends ChangeNotifier {
  // ── Shared State (Protected for subclasses) ──
  int currentIndex = 0;
  String? sessionError;
  Map<String, CardTemplate> templates = {};
  Map<QuizAnswerType, String> nextIntervals = {};

  // ── THE NEW TOGGLE ──
  bool realTimeSaving = false;

  // ── Abstract Contract (Subclasses MUST implement) ──
  bool get isComplete;
  ReviewCard? get currentReviewCard;

  void submitAnswer(String userAnswer, QuizAnswerType type);
  Future<void> completeSession(); // <-- Pulled up to the base class
  void reset();

  // ── Shared Getters ──
  String? get error => sessionError;

  CardTemplate? get currentTemplate => currentReviewCard != null
      ? templates[currentReviewCard!.templateId]
      : null;

  // ── Shared Utilities ──
  fsrs.Rating mapToFsrsRating(QuizAnswerType type) {
    return switch (type) {
      QuizAnswerType.again => fsrs.Rating.again,
      QuizAnswerType.hard => fsrs.Rating.hard,
      QuizAnswerType.good => fsrs.Rating.good,
      QuizAnswerType.easy => fsrs.Rating.easy,
      QuizAnswerType.incorrect => fsrs.Rating.again,
    };
  }

  String formatInterval(DateTime now, DateTime nextReview) {
    final diff = nextReview.difference(now);
    if (diff.inMinutes < 1) return '< 1m';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';

    final days = diff.inDays;
    if (days < 30) return '${days}d';
    if (days < 365) {
      final months = (days / 30).toStringAsFixed(1);
      return '${months.endsWith('.0') ? months.substring(0, months.length - 2) : months}mo';
    }

    final years = (days / 365).toStringAsFixed(1);
    return '${years.endsWith('.0') ? years.substring(0, years.length - 2) : years}y';
  }

  void clearError() {
    sessionError = null;
    notifyListeners();
  }

  Future<void> calculateNextIntervals();

  // ── Shared FSRS Math (Protected for subclasses) ──
  @protected
  void generateIntervalsForState(fsrs.Card baseState) {
    nextIntervals.clear();

    final scheduler = fsrs.Scheduler();
    final now = DateTime.now();

    final again = scheduler.reviewCard(baseState, fsrs.Rating.again);
    final hard = scheduler.reviewCard(baseState, fsrs.Rating.hard);
    final good = scheduler.reviewCard(baseState, fsrs.Rating.good);
    final easy = scheduler.reviewCard(baseState, fsrs.Rating.easy);

    nextIntervals = {
      QuizAnswerType.again: formatInterval(now, again.card.due),
      QuizAnswerType.hard: formatInterval(now, hard.card.due),
      QuizAnswerType.good: formatInterval(now, good.card.due),
      QuizAnswerType.easy: formatInterval(now, easy.card.due),
    };

    notifyListeners();
  }
}
