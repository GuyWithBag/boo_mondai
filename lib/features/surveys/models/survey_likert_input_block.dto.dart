import 'package:boo_mondai/features/surveys/models/survey_block.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'survey_likert_input_block.dto.mapper.dart';

@MappableClass(discriminatorValue: 'likert_input')
final class SurveyLikertInputBlock extends SurveyBlock
    with SurveyLikertInputBlockMappable {
  final String key;
  final String prompt;
  final String? description;
  final bool isRequired;
  final int minValue;
  final int maxValue;
  final String? minLabel;
  final String? maxLabel;

  const SurveyLikertInputBlock({
    required super.id,
    required super.surveyId,
    required super.pageId,
    required super.position,
    required this.key,
    required this.prompt,
    this.description,
    this.isRequired = true,
    this.minValue = 1,
    this.maxValue = 5,
    this.minLabel,
    this.maxLabel,
  });

  @override
  bool get collectsAnswer => true;
}
