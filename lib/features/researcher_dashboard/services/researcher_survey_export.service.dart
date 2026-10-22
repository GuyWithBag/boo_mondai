import 'dart:convert';

import 'package:boo_mondai/lib.barrel.dart'
    show CsvHelper, SurveyBlockHelper, SurveyDefinition, SurveyResponse;

final class ResearcherSurveyExportPayload {
  const ResearcherSurveyExportPayload({required this.json, required this.csv});

  final String json;
  final String csv;
}

abstract final class ResearcherSurveyExportService {
  static ResearcherSurveyExportPayload build({
    required SurveyDefinition definition,
    required List<SurveyResponse> responses,
  }) {
    return ResearcherSurveyExportPayload(
      json: _buildJson(definition: definition, responses: responses),
      csv: _buildCsv(definition: definition, responses: responses),
    );
  }

  static String _buildJson({
    required SurveyDefinition definition,
    required List<SurveyResponse> responses,
  }) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert({
      'survey': definition.survey.toMap(),
      'pages': definition.pages.map((page) => page.toMap()).toList(),
      'blocks': definition.blocks.map((block) => block.toMap()).toList(),
      'responses': responses.map((response) => response.toMap()).toList(),
    });
  }

  static String _buildCsv({
    required SurveyDefinition definition,
    required List<SurveyResponse> responses,
  }) {
    final rows = <List<String>>[
      [
        'response_id',
        'survey_id',
        'profile_id',
        'submitted_at',
        'question_key',
        'question_prompt',
        'answer',
      ],
    ];

    final answerBlocks = definition.blocks.where(
      (block) => block.collectsAnswer,
    );
    for (final response in responses) {
      for (final block in answerBlocks) {
        final key = SurveyBlockHelper.keyFor(block);
        rows.add([
          response.id,
          response.surveyId,
          response.profileId,
          response.submittedAt.toIso8601String(),
          key,
          SurveyBlockHelper.promptFor(block),
          _formatAnswer(response.answers[key]),
        ]);
      }
    }

    return CsvHelper.rows(rows);
  }

  static String _formatAnswer(dynamic value) {
    if (value == null) return '';
    if (value is List) return value.join('|');
    return value.toString();
  }
}
