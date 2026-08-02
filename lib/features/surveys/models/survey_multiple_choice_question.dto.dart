import 'package:boo_mondai/features/surveys/models/survey_choice_option.dto.dart';
import 'package:boo_mondai/features/surveys/models/survey_question.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'survey_multiple_choice_question.dto.mapper.dart';

@MappableClass(discriminatorValue: 'multiple_choice')
final class SurveyMultipleChoiceQuestion extends SurveyQuestion
    with SurveyMultipleChoiceQuestionMappable {
  final List<SurveyChoiceOption> options;
  final int minAnswers;
  final int maxAnswers;

  const SurveyMultipleChoiceQuestion({
    required super.id,
    required super.surveyId,
    required super.position,
    required super.key,
    required super.title,
    super.description,
    super.isRequired,
    required this.options,
    this.minAnswers = 1,
    this.maxAnswers = 1,
  });

  bool get isSingleChoice => maxAnswers == 1;
}
