// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/survey_response.dart
// PURPOSE: Generic survey response wrapping all survey types
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dart_mappable/dart_mappable.dart';

part 'survey_response.mapper.dart';

@MappableClass()
class SurveyResponse with SurveyResponseMappable {
  final String id;
  final String userId;
  final String surveyType;
  final String? timePoint;
  final Map<String, dynamic> responses;
  final double? computedScore;
  final DateTime submittedAt;

  const SurveyResponse({
    required this.id,
    required this.userId,
    required this.surveyType,
    this.timePoint,
    required this.responses,
    this.computedScore,
    required this.submittedAt,
  });
}
