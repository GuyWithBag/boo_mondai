import 'package:boo_mondai/features/surveys/models/survey_assignment.status.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'survey_assignment.dto.mapper.dart';

@MappableClass()
class SurveyAssignment with SurveyAssignmentMappable {
  final String id;
  final String surveyId;
  final String profileId;
  final SurveyAssignmentStatus status;
  final DateTime assignedAt;
  final DateTime? dueAt;
  final DateTime? completedAt;

  const SurveyAssignment({
    required this.id,
    required this.surveyId,
    required this.profileId,
    this.status = SurveyAssignmentStatus.pending,
    required this.assignedAt,
    this.dueAt,
    this.completedAt,
  });
}
