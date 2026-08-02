import 'package:boo_mondai/features/surveys/models/survey_question.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'survey_text_question.dto.mapper.dart';

@MappableClass(discriminatorValue: 'text')
final class SurveyTextQuestion extends SurveyQuestion
    with SurveyTextQuestionMappable {
  final bool isLongText;
  final String? placeholder;
  final int? minLength;
  final int? maxLength;

  const SurveyTextQuestion({
    required super.id,
    required super.surveyId,
    required super.position,
    required super.key,
    required super.title,
    super.description,
    super.isRequired,
    this.isLongText = false,
    this.placeholder,
    this.minLength,
    this.maxLength,
  });
}
