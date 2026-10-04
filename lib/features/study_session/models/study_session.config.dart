import 'package:boo_mondai/lib.barrel.dart' show SessionMode;

final class StudySessionConfig {
  const StudySessionConfig({
    required this.mode,
    required this.autoRateIncorrectAnswers,
    required this.requeueIncorrectAnswers,
    required this.requeueAgainWhenIntervalLessThan,
    required this.saveAfterEachAnswer,
    this.showCardsByBatch,
  });

  const StudySessionConfig.drill()
    : mode = SessionMode.drill,
      autoRateIncorrectAnswers = true,
      requeueIncorrectAnswers = true,
      saveAfterEachAnswer = false,
      showCardsByBatch = 10,
      requeueAgainWhenIntervalLessThan = null;

  const StudySessionConfig.spacedRepitition({
    this.requeueAgainWhenIntervalLessThan,
    this.showCardsByBatch,
  }) : mode = SessionMode.review,
       autoRateIncorrectAnswers = false,
       requeueIncorrectAnswers = false,
       saveAfterEachAnswer = true;

  final SessionMode mode;
  final bool autoRateIncorrectAnswers;
  final bool requeueIncorrectAnswers;
  final bool saveAfterEachAnswer;
  final int? showCardsByBatch;
  final Duration? requeueAgainWhenIntervalLessThan;
}
