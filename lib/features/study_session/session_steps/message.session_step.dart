import 'package:boo_mondai/features/study_session/session_steps/session_step.dto.dart';

final class StudySessionMessageStep extends StudySessionStep {
  final String messageDefinitionId;
  final String title;
  final String message;

  const StudySessionMessageStep({
    required super.id,
    required this.messageDefinitionId,
    required this.title,
    required this.message,
    super.insertedByRuleId,
    super.insertionReason,
  });
}
