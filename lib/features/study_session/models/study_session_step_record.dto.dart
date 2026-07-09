import 'package:boo_mondai/features/study_session/models/study_rating.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'study_session_step_record.dto.mapper.dart';

@MappableClass()
final class StudySessionStepRecord with StudySessionStepRecordMappable {
  final String id;
  final String sessionId;
  final String stepId;
  final String studyCardId;
  final int sequenceNumber;
  final int attemptNumber;
  final String userAnswer;
  final StudyRating rating;
  final DateTime enteredAt;
  final DateTime completedAt;
  final String? drillAnswerId;
  final String? fsrsReviewLogId;

  const StudySessionStepRecord({
    required this.id,
    required this.sessionId,
    required this.stepId,
    required this.studyCardId,
    required this.sequenceNumber,
    required this.attemptNumber,
    required this.userAnswer,
    required this.rating,
    required this.enteredAt,
    required this.completedAt,
    this.drillAnswerId,
    this.fsrsReviewLogId,
  });
}
