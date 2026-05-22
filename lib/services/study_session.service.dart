import 'dart:developer' as dev;

import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/exceptions/exceptions.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/services/services.dart';
import 'package:boo_mondai/widgets/drill_session/rating_area.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

class StudySessionService {
  // ── Shared Utilities ──
  static fsrs.Rating studyRatingToFSRSRating(StudyRating type) {
    return switch (type) {
      StudyRating.again => fsrs.Rating.again,
      StudyRating.hard => fsrs.Rating.hard,
      StudyRating.good => fsrs.Rating.good,
      StudyRating.easy => fsrs.Rating.easy,
      StudyRating.incorrect => fsrs.Rating.again,
    };
  }

  static StudyRating fromFSRSRatingToStudyRating(fsrs.Rating rating) {
    // FIX: Must include the 'Rating' enum name on every case
    switch (rating) {
      case fsrs.Rating.again:
        return StudyRating.again;
      case fsrs.Rating.hard:
        return StudyRating.hard;
      case fsrs.Rating.good:
        return StudyRating.good;
      case fsrs.Rating.easy:
        return StudyRating.easy;
    }
  }

  static SubmissionStyle getSubmissionStyle(CardTemplate template) {
    if (template is FlashcardTemplate) {
      return SubmissionStyle.showAnswer;
    } else if (template is MultipleChoiceTemplate) {
      return SubmissionStyle.submitAnswer;
    }

    return SubmissionStyle.submitAnswer;
  }

  static bool isAutoGraded(CardTemplate template) {
    return template is MultipleChoiceTemplate ||
        template is FillInTheBlanksTemplate;
  }

  static bool isAnswerCorrect(CardTemplate template, String userAnswer) {
    if (template is FillInTheBlanksTemplate) {
      final answers = userAnswer.split('|');
      return template.segments.isNotEmpty &&
          answers.length == template.segments.length &&
          template.segments.asMap().entries.every((entry) {
            return entry.value.checkAnswer(answers[entry.key]);
          });
    }

    return template.checkAnswer(userAnswer);
  }

  static String formatFSRSInterval(DateTime now, DateTime nextReview) {
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

  // ── Shared FSRS Math (Protected for subclasses) ──
  static Map<StudyRating, String> generateIntervalsForState(
    fsrs.Card baseState,
  ) {
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

      return {
        StudyRating.again: StudySessionService.formatFSRSInterval(
          displayNow,
          again.card.due.toLocal(),
        ),
        StudyRating.hard: StudySessionService.formatFSRSInterval(
          displayNow,
          hard.card.due.toLocal(),
        ),
        StudyRating.good: StudySessionService.formatFSRSInterval(
          displayNow,
          good.card.due.toLocal(),
        ),
        StudyRating.easy: StudySessionService.formatFSRSInterval(
          displayNow,
          easy.card.due.toLocal(),
        ),
      };
    } catch (e, stackTrace) {
      // If it ever errors out again, we can at least see why in the console
      dev.log('FSRS Interval Calculation Error: $e');
      throw SessionException(
        'Failed to calculate FSRS review intervals.',
        code: 'FSRS_INTERVAL_CALCULATION_FAILED',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  static int getCurrentCount(
    StudySessionController controller,
    SessionMode mode,
  ) {
    if (mode == SessionMode.drill) {
      return (controller as DrillSessionController).correctCount;
    }
    return controller.currentIndex + 1;
  }

  static int getTotalCount(
    StudySessionController controller,
    SessionMode mode,
  ) {
    if (mode == SessionMode.drill) {
      final session = (controller as DrillSessionController).session;
      if (session == null) {
        throw const SessionException(
          'Cannot get total count before a drill session has started.',
          code: 'DRILL_SESSION_MISSING',
        );
      }

      return session.totalQuestions;
    }

    final session = (controller as ReviewSessionController).session;
    if (session == null) {
      throw const SessionException(
        'Cannot get total count before a review session has started.',
        code: 'REVIEW_SESSION_MISSING',
      );
    }

    return session.totalCards;
  }
}
