import 'package:dart_mappable/dart_mappable.dart';

part 'survey_page.dto.mapper.dart';

@MappableClass()
class SurveyPage with SurveyPageMappable {
  final String id;
  final String surveyId;
  final int position;
  final String? title;

  const SurveyPage({
    required this.id,
    required this.surveyId,
    required this.position,
    this.title,
  });
}
