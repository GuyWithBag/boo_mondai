import 'package:boo_mondai/features/study_session/models/study_rating.dto.dart';
import 'package:boo_mondai/features/study_session/session_mode.dart';

final class StudySessionRuleContext {
  const StudySessionRuleContext({
    required this.sessionId,
    required this.currentStepId,
    required this.mode,
    required this.latestRating,
    required this.consecutiveCorrectAnswers,
    required this.consecutiveIncorrectAnswers,
    required this.completedCardCount,
    required this.remainingCardCount,
    required this.accuracy,
    required this.elapsed,
    required this.firedRuleKeys,
  });

  final String sessionId;
  final String currentStepId;
  final SessionMode mode;
  final StudyRating? latestRating;
  final int consecutiveCorrectAnswers;
  final int consecutiveIncorrectAnswers;
  final int completedCardCount;
  final int remainingCardCount;
  final double accuracy;
  final Duration elapsed;
  final Set<String> firedRuleKeys;
}
