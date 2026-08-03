import 'package:boo_mondai/features/surveys/models/survey_block.dto.dart';
import 'package:boo_mondai/features/surveys/models/survey_choice_option.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'survey_multiple_choice_input_block.dto.mapper.dart';

@MappableClass(discriminatorValue: 'multiple_choice_input')
final class SurveyMultipleChoiceInputBlock extends SurveyBlock
    with SurveyMultipleChoiceInputBlockMappable {
  final String key;
  final String prompt;
  final String? description;
  final bool isRequired;
  final List<SurveyChoiceOption> options;
  final int minAnswers;
  final int maxAnswers;

  const SurveyMultipleChoiceInputBlock({
    required super.id,
    required super.surveyId,
    required super.pageId,
    required super.position,
    required this.key,
    required this.prompt,
    this.description,
    this.isRequired = true,
    required this.options,
    this.minAnswers = 1,
    this.maxAnswers = 1,
  });

  bool get isSingleChoice => maxAnswers == 1;

  @override
  bool get collectsAnswer => true;
}
