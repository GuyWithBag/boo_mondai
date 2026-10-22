import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonVariant,
        DateHelper,
        ResearcherSurveySummary,
        SurfaceColor,
        SurfaceShadow,
        surfaceStyle,
        textStyle,
        TextColor,
        TextSize,
        TextWeight;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class ResearcherSurveyTile extends StatelessWidget {
  const ResearcherSurveyTile({
    required this.summary,
    required this.onPressed,
    super.key,
  });

  final ResearcherSurveySummary summary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final lastSubmittedAt = summary.lastSubmittedAt;

    return Surface(
      style: surfaceStyle.resolve(tokens, const [
        SurfaceColor.baseline,
        SurfaceShadow.none,
      ]),
      child: Column(
        spacing: tokens.spaceLayoutGapSm,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  summary.title,
                  style: textStyle.resolve(tokens, const [
                    TextSize.header,
                    TextWeight.heavy,
                  ]),
                ),
              ),
              Text(
                '${summary.responseCount} responses',
                style: textStyle.resolve(tokens, const [
                  TextSize.label,
                  TextWeight.heavy,
                  TextColor.muted,
                ]),
              ),
            ],
          ),
          if (summary.description.trim().isNotEmpty)
            Text(
              summary.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textStyle.resolve(tokens, const [
                TextSize.label,
                TextColor.muted,
              ]),
            ),
          Text(
            lastSubmittedAt == null
                ? 'No submissions yet'
                : 'Last submitted ${DateHelper.formatDateYyyyMmDd(lastSubmittedAt)}',
            style: textStyle.resolve(tokens, const [
              TextSize.labelSmall,
              TextColor.muted,
            ]),
          ),
          Button(
            variants: const [ButtonVariant.flat],
            leading: const Icon(Icons.analytics_outlined),
            onPressed: onPressed,
            child: const Text('View survey data'),
          ),
        ],
      ),
    );
  }
}
