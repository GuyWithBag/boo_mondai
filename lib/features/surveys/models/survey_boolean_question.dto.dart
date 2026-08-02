import 'package:boo_mondai/features/surveys/models/survey_question.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'survey_boolean_question.dto.mapper.dart';

@MappableClass(discriminatorValue: 'boolean')
final class SurveyBooleanQuestion extends SurveyQuestion
    with SurveyBooleanQuestionMappable {
  final String trueLabel;
  final String falseLabel;

  const SurveyBooleanQuestion({
    required super.id,
    required super.surveyId,
    required super.position,
    required super.key,
    required super.title,
    super.description,
    super.isRequired,
    this.trueLabel = 'Yes',
    this.falseLabel = 'No',
  });
}
