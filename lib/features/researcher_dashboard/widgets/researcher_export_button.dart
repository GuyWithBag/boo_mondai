import 'package:boo_mondai/lib.barrel.dart'
    show Button, SurveyDefinition, SurveyResponse;
import 'package:flutter/material.dart';

class ResearcherExportButton extends StatelessWidget {
  const ResearcherExportButton({
    required this.definition,
    required this.responses,
    super.key,
  });

  final SurveyDefinition definition;
  final List<SurveyResponse> responses;

  @override
  Widget build(BuildContext context) {
    return Button(
      leading: const Icon(Icons.ios_share_rounded),
      onPressed: () {
        // final payload = ResearcherSurveyExportService.build(
        //   definition: definition,
        //   responses: responses,
        // );
        // showExportPayloadModal(
        //   context: context,
        //   title: 'Export survey data',
        //   body: 'Export ${responses.length} responses as JSON.',
        //   payloadJson: payload.json,
        // );
      },
      child: const Text('Export Data'),
    );
  }
}
