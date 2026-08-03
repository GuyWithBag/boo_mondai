import 'package:boo_mondai/features/surveys/models/survey_boolean_input_block.dto.dart';
import 'package:boo_mondai/features/surveys/models/survey_content_block.dto.dart';
import 'package:boo_mondai/features/surveys/models/survey_likert_input_block.dto.dart';
import 'package:boo_mondai/features/surveys/models/survey_multiple_choice_input_block.dto.dart';
import 'package:boo_mondai/features/surveys/models/survey_number_input_block.dto.dart';
import 'package:boo_mondai/features/surveys/models/survey_text_input_block.dto.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'survey_block.dto.mapper.dart';

@MappableClass(
  discriminatorKey: 'block_type',
  includeSubClasses: [
    SurveyContentBlock,
    SurveyTextInputBlock,
    SurveyNumberInputBlock,
    SurveyMultipleChoiceInputBlock,
    SurveyLikertInputBlock,
    SurveyBooleanInputBlock,
  ],
)
abstract class SurveyBlock with SurveyBlockMappable {
  final String id;
  final String surveyId;
  final String pageId;
  final int position;

  const SurveyBlock({
    required this.id,
    required this.surveyId,
    required this.pageId,
    required this.position,
  });

  bool get collectsAnswer;
}
