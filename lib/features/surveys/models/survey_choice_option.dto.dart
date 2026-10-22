import 'package:dart_mappable/dart_mappable.dart';

part 'survey_choice_option.dto.mapper.dart';

@MappableClass()
class SurveyChoiceOption with SurveyChoiceOptionMappable {
  final String id;
  final String blockId;
  final int position;
  final String value;
  final String label;

  const SurveyChoiceOption({
    required this.id,
    required this.blockId,
    required this.position,
    required this.value,
    required this.label,
  });
}
