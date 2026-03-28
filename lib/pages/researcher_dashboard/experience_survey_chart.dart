// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/researcher_dashboard/experience_survey_chart.dart
// PURPOSE: Displays experience survey subscale averages (Enjoyment, Engagement, Motivation)
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.dart';
import 'package:boo_mondai/pages/researcher_dashboard/score_bar.dart';

class ExperienceSurveyChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const ExperienceSurveyChart({super.key, required this.data});

  double _avg(List<Map<String, dynamic>> rows, List<String> keys) {
    if (rows.isEmpty) return 0;
    var total = 0.0;
    var count = 0;
    for (final row in rows) {
      for (final key in keys) {
        final v = row[key];
        if (v != null) {
          total += (v as num).toDouble();
          count++;
        }
      }
    }
    return count == 0 ? 0 : total / count;
  }

  @override
  Widget build(BuildContext context) {
    final enjoymentAvg = _avg(
        data, ['enjoyment_1', 'enjoyment_2', 'enjoyment_3', 'enjoyment_4', 'enjoyment_5']);
    final engagementAvg = _avg(
        data, ['engagement_1', 'engagement_2', 'engagement_3', 'engagement_4', 'engagement_5']);
    final motivationAvg = _avg(
        data, ['motivation_1', 'motivation_2', 'motivation_3', 'motivation_4', 'motivation_5']);

    return Column(
      children: [
        ScoreBar(
            label: 'Enjoyment',
            value: enjoymentAvg,
            max: 5,
            valueLabel: enjoymentAvg.toStringAsFixed(2)),
        const SizedBox(height: AppSpacing.sm),
        ScoreBar(
            label: 'Engagement',
            value: engagementAvg,
            max: 5,
            valueLabel: engagementAvg.toStringAsFixed(2)),
        const SizedBox(height: AppSpacing.sm),
        ScoreBar(
            label: 'Motivation',
            value: motivationAvg,
            max: 5,
            valueLabel: motivationAvg.toStringAsFixed(2)),
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
