import 'package:boo_mondai/features/study_session/models/session_step.dto.dart';

sealed class SessionFlowCommand {
  const SessionFlowCommand({this.occurrenceKey});

  final String? occurrenceKey;
}

final class InsertAfterCurrent extends SessionFlowCommand {
  const InsertAfterCurrent({required this.step, super.occurrenceKey});

  final SessionStep step;
}

final class AppendSessionStep extends SessionFlowCommand {
  const AppendSessionStep({required this.step, super.occurrenceKey});

  final SessionStep step;
}

final class RequeueCard extends SessionFlowCommand {
  const RequeueCard({
    required this.studyCardId,
    required this.reason,
    super.occurrenceKey,
  });

  final String studyCardId;
  final String reason;
}
