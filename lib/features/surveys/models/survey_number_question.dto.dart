import 'package:boo_mondai/features/surveys/models/survey_question.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'survey_number_question.dto.mapper.dart';

@MappableClass(discriminatorValue: 'number')
final class SurveyNumberQuestion extends SurveyQuestion
    with SurveyNumberQuestionMappable {
  final num? minValue;
  final num? maxValue;
  final num? step;

  const SurveyNumberQuestion({
    required super.id,
    required super.surveyId,
    required super.position,
    required super.key,
    required super.title,
    super.description,
    super.isRequired,
    this.minValue,
    this.maxValue,
    this.step,
  });
}
