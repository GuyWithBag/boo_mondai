// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/shared/interfaces/session_controller.dart
// PURPOSE: Abstract base class centralizing shared Drill and FSRS logic
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/services/services.barrel.dart';
import 'package:flutter/foundation.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

abstract class StudySessionController extends ChangeNotifier {
  // ── Shared State (Protected for subclasses) ──
  int currentIndex = 0;
  String? sessionError;
  Map<String, CardTemplate> templates = {};
  Map<StudyRating, String> nextIntervals = {};

  // ── THE NEW TOGGLE ──
  bool realTimeSaving = false;

  // ── Abstract Contract (Subclasses MUST implement) ──
  bool get isComplete;
  ReviewCard? get currentReviewCard;
  double get progress;

  void submitAnswer(String userAnswer, StudyRating type);
  Future<void> completeSession(); // <-- Pulled up to the base class
  void reset();

  // bool get isCardRevealed => isCardRevealed;
  // bool isCardRevealed = false;
  set isCardRevealed(bool value) {
    isCardRevealed = value;
    notifyListeners();
  }

  // ── Shared Getters ──
  String? get error => sessionError;

  CardTemplate? get currentTemplate => currentReviewCard != null
      ? templates[currentReviewCard!.templateId]
      : null;

  // ── Shared Utilities ──
  fsrs.Rating mapToFsrsRating(StudyRating type) {
    return switch (type) {
      StudyRating.again => fsrs.Rating.again,
      StudyRating.hard => fsrs.Rating.hard,
      StudyRating.good => fsrs.Rating.good,
      StudyRating.easy => fsrs.Rating.easy,
      StudyRating.incorrect => fsrs.Rating.again,
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

    final now = DateTime.now();

    // ── THE TIME TRAVEL TRICK FOR BUTTON LABELS ──
    DateTime? customReviewTime;
    if (baseState.due.isAfter(now)) {
      customReviewTime = baseState.due;
    }

    // FSRS STRICT REQUIREMENT: MUST BE UTC
    final utcReviewTime = customReviewTime?.toUtc() ?? now.toUtc();

    // For the UI display, we calculate the interval relative to the time
    // we are pretending it is, so the buttons say "10m" instead of "1 day 10m"
    final displayNow = customReviewTime ?? now;

    try {
      // Pass the UTC review time to the scheduler so it doesn't crash!
      final again = Services.fsrs.scheduler.reviewCard(
        baseState.copyWith(),
        fsrs.Rating.again,
        reviewDateTime: utcReviewTime,
      );
      final hard = Services.fsrs.scheduler.reviewCard(
        baseState.copyWith(),
        fsrs.Rating.hard,
        reviewDateTime: utcReviewTime,
      );
      final good = Services.fsrs.scheduler.reviewCard(
        baseState.copyWith(),
        fsrs.Rating.good,
        reviewDateTime: utcReviewTime,
      );
      final easy = Services.fsrs.scheduler.reviewCard(
        baseState.copyWith(),
        fsrs.Rating.easy,
        reviewDateTime: utcReviewTime,
      );

      // Print the raw FSRS due dates and the calculated durations
      // print('--- FSRS DEBUG ---');
      // print('Base Due: ${baseState.due}');
      // print('Review Time: $utcReviewTime');
      // print(
      //   'Again Next Due: ${again.card.due} | Difference: ${again.card.due.difference(utcReviewTime)}',
      // );
      // print(
      //   'Good Next Due:  ${good.card.due} | Difference: ${good.card.due.difference(utcReviewTime)}',
      // );
      // print('------------------');

      nextIntervals = {
        StudyRating.again: formatInterval(displayNow, again.card.due.toLocal()),
        StudyRating.hard: formatInterval(displayNow, hard.card.due.toLocal()),
        StudyRating.good: formatInterval(displayNow, good.card.due.toLocal()),
        StudyRating.easy: formatInterval(displayNow, easy.card.due.toLocal()),
      };
    } catch (e) {
      // If it ever errors out again, we can at least see why in the console
      debugPrint('FSRS Interval Calculation Error: $e');
    }

    notifyListeners();
  }
}
