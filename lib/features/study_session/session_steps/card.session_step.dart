import 'package:boo_mondai/features/study_session/session_steps/session_step.dto.dart';

final class StudySessionCardStep extends StudySessionStep {
  final String studyCardId;
  final int attemptNumber;

  const StudySessionCardStep({
    required super.id,
    required this.studyCardId,
    this.attemptNumber = 1,
    super.insertedByRuleId,
    super.insertionReason,
  });
}
