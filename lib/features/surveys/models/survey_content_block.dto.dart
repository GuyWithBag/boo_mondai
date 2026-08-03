import 'package:boo_mondai/features/surveys/models/survey_block.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'survey_content_block.dto.mapper.dart';

@MappableClass(discriminatorValue: 'content')
final class SurveyContentBlock extends SurveyBlock
    with SurveyContentBlockMappable {
  final String markdown;

  const SurveyContentBlock({
    required super.id,
    required super.surveyId,
    required super.pageId,
    required super.position,
    required this.markdown,
  });

  @override
  bool get collectsAnswer => false;
}
