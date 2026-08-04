import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        MarkdownText,
        MarkdownTextMode,
        SurveyBlockField,
        SurveyDefinition,
        SurveyResponse,
        TextColor,
        TextSize,
        textStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class ResearcherSurveyPreview extends StatelessWidget {
  const ResearcherSurveyPreview({
    required this.definition,
    this.response,
    super.key,
  });

  final SurveyDefinition definition;
  final SurveyResponse? response;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Column(
      spacing: tokens.spaceLayoutGapLg,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (definition.survey.description.trim().isNotEmpty)
          MarkdownText(
            data: definition.survey.description,
            mode: MarkdownTextMode.previewSelectable,
            defaultMarkdownAlignment: WrapAlignment.start,
          ),
        if (response != null)
          Text(
            'Showing response from ${response!.profileId} submitted '
            '${response!.submittedAt.toLocal()}',
            style: textStyle.resolve(tokens, const [
              TextSize.labelSmall,
              TextColor.muted,
            ]),
          ),
        for (final page in definition.pages) ...[
          if (page.title != null)
            Text(page.title!, style: Theme.of(context).textTheme.titleLarge),
          for (final block
              in definition.blocks
                  .where((block) => block.pageId == page.id)
                  .toList()
                ..sort((a, b) => a.position.compareTo(b.position)))
            SurveyBlockField(
              block: block,
              readOnly: true,
              answers: response?.answers ?? const {},
            ),
        ],
      ],
    );
  }
}
