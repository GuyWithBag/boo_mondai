import 'package:boo_mondai/lib.barrel.dart'
    show Survey, SurveyBlock, SurveyPage;

final class SurveyDefinition {
  const SurveyDefinition({
    required this.survey,
    required this.pages,
    required this.blocks,
  });

  final Survey survey;
  final List<SurveyPage> pages;
  final List<SurveyBlock> blocks;

  String get id => survey.id;
}
