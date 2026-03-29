// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/researcher_dashboard/likert_survey_chart.dart
// PURPOSE: Generic Likert survey chart displaying per-item score bars
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class LikertSurveyChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final int itemCount;

  const LikertSurveyChart({
    super.key,
    required this.data,
    required this.itemCount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 1; i <= itemCount; i++) ...[
          if (i > 1) const SizedBox(height: AppSpacing.xs),
          ScoreBar(
            label: 'Item $i',
            value: data.isEmpty
                ? 0
                : data
                          .map((e) => (e['item_$i'] as num?)?.toDouble() ?? 0.0)
                          .reduce((a, b) => a + b) /
                      data.length,
            max: 5,
            valueLabel: data.isEmpty
                ? '—'
                : (data
                              .map(
                                (e) =>
                                    (e['item_$i'] as num?)?.toDouble() ?? 0.0,
                              )
                              .reduce((a, b) => a + b) /
                          data.length)
                      .toStringAsFixed(2),
          ),
        ],
        if (data.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: Text(
              'No submissions yet',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}
