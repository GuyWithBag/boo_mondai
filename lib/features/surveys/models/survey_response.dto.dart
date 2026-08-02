import 'package:dart_mappable/dart_mappable.dart';

part 'survey_response.dto.mapper.dart';

@MappableClass()
class SurveyResponse with SurveyResponseMappable {
  final String id;
  final String surveyId;
  final String profileId;
  final String? assignmentId;
  final Map<String, dynamic> answers;
  final DateTime submittedAt;

  const SurveyResponse({
    required this.id,
    required this.surveyId,
    required this.profileId,
    this.assignmentId,
    required this.answers,
    required this.submittedAt,
  });
}
