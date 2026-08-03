import 'package:boo_mondai/features/surveys/models/survey_block.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'survey_text_input_block.dto.mapper.dart';

@MappableClass(discriminatorValue: 'text_input')
final class SurveyTextInputBlock extends SurveyBlock
    with SurveyTextInputBlockMappable {
  final String key;
  final String prompt;
  final String? description;
  final bool isRequired;
  final bool isLongText;
  final String? placeholder;
  final int? minLength;
  final int? maxLength;

  const SurveyTextInputBlock({
    required super.id,
    required super.surveyId,
    required super.pageId,
    required super.position,
    required this.key,
    required this.prompt,
    this.description,
    this.isRequired = true,
    this.isLongText = false,
    this.placeholder,
    this.minLength,
    this.maxLength,
  });

  @override
  bool get collectsAnswer => true;
}
