import 'package:boo_mondai/lib.barrel.dart'
    show SurveyDefinition, SurveyResponse;

final class ResearcherSurveySummary {
  const ResearcherSurveySummary({
    required this.definition,
    required this.responses,
  });

  final SurveyDefinition definition;
  final List<SurveyResponse> responses;

  String get id => definition.id;
  String get title => definition.survey.title;
  String get description => definition.survey.description;
  int get responseCount => responses.length;

  DateTime? get lastSubmittedAt {
    DateTime? latest;
    for (final response in responses) {
      if (latest == null || response.submittedAt.isAfter(latest)) {
        latest = response.submittedAt;
      }
    }
    return latest;
  }
}
