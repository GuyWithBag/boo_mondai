import 'dart:developer' as dev;

import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        DrillSessionController,
        FillInTheBlanksTemplate,
        FlashcardTemplate,
        MultipleChoiceTemplate,
        ReviewSessionController,
        Services,
        SessionException,
        SessionMode,
        StudyRating,
        StudySessionController,
        SubmissionStyle;
import 'package:fsrs/fsrs.dart' as fsrs;

abstract final class StudySessionHelper {
  static SubmissionStyle getSubmissionStyle(CardTemplate template) {
    if (template is FlashcardTemplate) {
      return SubmissionStyle.showAnswer;
    }
    return SubmissionStyle.submitAnswer;
  }

  static bool isAutoGraded(CardTemplate template) {
    return template is MultipleChoiceTemplate ||
        template is FillInTheBlanksTemplate;
  }

  static String formatFsrsInterval(DateTime now, DateTime nextReview) {
    final diff = nextReview.difference(now);
    if (diff.inMinutes < 1) return '< 1m';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';

    final days = diff.inDays;
    if (days < 30) return '${days}d';
    if (days < 365) {
      final months = (days / 30).toStringAsFixed(1);
      return '${_withoutTrailingZero(months)}mo';
    }

    final years = (days / 365).toStringAsFixed(1);
    return '${_withoutTrailingZero(years)}y';
  }

  static Map<StudyRating, String> generateIntervalsForState(
    fsrs.Card baseState,
  ) {
    final now = DateTime.now();
    final reviewTime = baseState.due.isAfter(now) ? baseState.due : now;

    try {
      final scheduler = Services.fsrs.scheduler;
      final intervals = <StudyRating, fsrs.Rating>{
        StudyRating.again: fsrs.Rating.again,
        StudyRating.hard: fsrs.Rating.hard,
        StudyRating.good: fsrs.Rating.good,
        StudyRating.easy: fsrs.Rating.easy,
      };

      return intervals.map((rating, fsrsRating) {
        final result = scheduler.reviewCard(
          baseState.copyWith(),
          fsrsRating,
          reviewDateTime: reviewTime.toUtc(),
        );
        return MapEntry(
          rating,
          formatFsrsInterval(reviewTime, result.card.due.toLocal()),
        );
      });
    } catch (error, stackTrace) {
      dev.log('FSRS interval calculation error: $error');
      throw SessionException(
        'Failed to calculate FSRS review intervals.',
        code: 'FSRS_INTERVAL_CALCULATION_FAILED',
        originalError: error,
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

  static String _withoutTrailingZero(String value) {
    return value.endsWith('.0') ? value.substring(0, value.length - 2) : value;
  }
}
