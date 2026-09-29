import 'package:boo_mondai/lib.barrel.dart' show SessionMode;

final class StudySessionConfig {
  const StudySessionConfig({
    required this.mode,
    required this.autoRateIncorrectAnswers,
    required this.requeueIncorrectAnswers,
    required this.requeueAgainWhenIntervalLessThan,
  });

  const StudySessionConfig.drill()
    : mode = SessionMode.drill,
      autoRateIncorrectAnswers = true,
      requeueIncorrectAnswers = true,
      requeueAgainWhenIntervalLessThan = null;

  const StudySessionConfig.spacedRepitition({
    this.requeueAgainWhenIntervalLessThan,
  }) : mode = SessionMode.review,
       autoRateIncorrectAnswers = false,
       requeueIncorrectAnswers = false;

  final SessionMode mode;
  final bool autoRateIncorrectAnswers;
  final bool requeueIncorrectAnswers;
  final Duration? requeueAgainWhenIntervalLessThan;
}
