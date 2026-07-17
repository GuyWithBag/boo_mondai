import 'package:boo_mondai/lib.barrel.dart'
    show
        SessionStep,
        SessionStepCopyWith,
        SessionStepMapper,
        StudyRating,
        StudyRatingMapper;
import 'package:dart_mappable/dart_mappable.dart';

part 'session_flow_snapshot.dto.mapper.dart';

@MappableClass()
final class PendingStepSubmission with PendingStepSubmissionMappable {
  final String stepId;
  final String userAnswer;
  final StudyRating rating;
  final DateTime submittedAt;

  const PendingStepSubmission({
    required this.stepId,
    required this.userAnswer,
    required this.rating,
    required this.submittedAt,
  });
}

@MappableClass()
final class SessionFlowSnapshot with SessionFlowSnapshotMappable {
  final String sessionId;
  final String? currentStepId;
  final List<SessionStep> steps;
  final Set<String> firedRuleKeys;
  final PendingStepSubmission? pendingSubmission;
  final DateTime updatedAt;

  const SessionFlowSnapshot({
    required this.sessionId,
    required this.currentStepId,
    required this.steps,
    this.firedRuleKeys = const {},
    this.pendingSubmission,
    required this.updatedAt,
  });
}
