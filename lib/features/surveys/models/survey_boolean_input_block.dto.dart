import 'package:boo_mondai/features/surveys/models/survey_block.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'survey_boolean_input_block.dto.mapper.dart';

@MappableClass(discriminatorValue: 'boolean_input')
final class SurveyBooleanInputBlock extends SurveyBlock
    with SurveyBooleanInputBlockMappable {
  final String key;
  final String prompt;
  final String? description;
  final bool isRequired;
  final String trueLabel;
  final String falseLabel;

  const SurveyBooleanInputBlock({
    required super.id,
    required super.surveyId,
    required super.pageId,
    required super.position,
    required this.key,
    required this.prompt,
    this.description,
    this.isRequired = true,
    this.trueLabel = 'Yes',
    this.falseLabel = 'No',
  });

  @override
  bool get collectsAnswer => true;
}
