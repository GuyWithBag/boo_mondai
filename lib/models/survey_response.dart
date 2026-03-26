// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/survey_response.dart
// PURPOSE: Generic survey response wrapping all survey types
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class SurveyResponse {
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

  factory SurveyResponse.fromJson(Map<String, dynamic> json) =>
      SurveyResponse(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        surveyType: json['survey_type'] as String,
        timePoint: json['time_point'] as String?,
        responses: Map<String, dynamic>.from(json['responses'] as Map),
        computedScore: (json['computed_score'] as num?)?.toDouble(),
        submittedAt: DateTime.parse(json['submitted_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'survey_type': surveyType,
        'time_point': timePoint,
        'responses': responses,
        'computed_score': computedScore,
        'submitted_at': submittedAt.toIso8601String(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SurveyResponse &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'SurveyResponse(surveyType: $surveyType, timePoint: $timePoint)';
}
