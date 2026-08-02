import 'package:boo_mondai/features/surveys/models/survey_boolean_question.dto.dart';
import 'package:boo_mondai/features/surveys/models/survey_likert_question.dto.dart';
import 'package:boo_mondai/features/surveys/models/survey_multiple_choice_question.dto.dart';
import 'package:boo_mondai/features/surveys/models/survey_number_question.dto.dart';
import 'package:boo_mondai/features/surveys/models/survey_text_question.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'survey_question.dto.mapper.dart';

@MappableClass(
  discriminatorKey: 'question_type',
  includeSubClasses: [
    SurveyTextQuestion,
    SurveyNumberQuestion,
    SurveyMultipleChoiceQuestion,
    SurveyLikertQuestion,
    SurveyBooleanQuestion,
  ],
)
abstract class SurveyQuestion with SurveyQuestionMappable {
  final String id;
  final String surveyId;
  final int position;
  final String key;
  final String title;
  final String? description;
  final bool isRequired;

  const SurveyQuestion({
    required this.id,
    required this.surveyId,
    required this.position,
    required this.key,
    required this.title,
    this.description,
    this.isRequired = true,
  });
}
