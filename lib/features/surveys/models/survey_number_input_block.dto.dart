import 'package:boo_mondai/features/surveys/models/survey_block.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'survey_number_input_block.dto.mapper.dart';

@MappableClass(discriminatorValue: 'number_input')
final class SurveyNumberInputBlock extends SurveyBlock
    with SurveyNumberInputBlockMappable {
  final String key;
  final String prompt;
  final String? description;
  final bool isRequired;
  final num? minValue;
  final num? maxValue;
  final num? step;

  const SurveyNumberInputBlock({
    required super.id,
    required super.surveyId,
    required super.pageId,
    required super.position,
    required this.key,
    required this.prompt,
    this.description,
    this.isRequired = true,
    this.minValue,
    this.maxValue,
    this.step,
  });

  @override
  bool get collectsAnswer => true;
}
