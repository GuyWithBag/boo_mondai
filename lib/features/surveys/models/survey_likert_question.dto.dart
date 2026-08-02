import 'package:boo_mondai/features/surveys/models/survey_question.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'survey_likert_question.dto.mapper.dart';

@MappableClass(discriminatorValue: 'likert')
final class SurveyLikertQuestion extends SurveyQuestion
    with SurveyLikertQuestionMappable {
  final int minValue;
  final int maxValue;
  final String? minLabel;
  final String? maxLabel;

  const SurveyLikertQuestion({
    required super.id,
    required super.surveyId,
    required super.position,
    required super.key,
    required super.title,
    super.description,
    super.isRequired,
    this.minValue = 1,
    this.maxValue = 5,
    this.minLabel,
    this.maxLabel,
  });
}
