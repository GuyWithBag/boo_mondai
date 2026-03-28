// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/researcher_dashboard/sus_chart.dart
// PURPOSE: Displays SUS score average with threshold legend
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.dart';
import 'package:boo_mondai/pages/researcher_dashboard/score_bar.dart';
import 'package:boo_mondai/pages/researcher_dashboard/threshold_chip.dart';

class SusChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const SusChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final avg = data.isEmpty
        ? 0.0
        : data
                .map((e) => (e['sus_score'] as num).toDouble())
                .reduce((a, b) => a + b) /
            data.length;

    Color scoreColor(double s) {
      if (s >= 80) return AppColors.correct;
      if (s >= 68) return AppColors.easy;
      if (s >= 51) return AppColors.hard;
      return AppColors.incorrect;
    }

    String scoreLabel(double s) {
      if (s >= 80) return 'Excellent';
      if (s >= 68) return 'Good';
      if (s >= 51) return 'OK';
      return 'Poor';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScoreBar(
          label: 'Avg SUS score',
          value: avg,
          max: 100,
          color: scoreColor(avg),
          valueLabel: '${avg.toStringAsFixed(1)} — ${scoreLabel(avg)}',
        ),
        const SizedBox(height: AppSpacing.sm),
        // Threshold legend
        Row(
          children: [
            ThresholdChip(label: '< 51 Poor', color: AppColors.incorrect),
            const SizedBox(width: AppSpacing.xs),
            ThresholdChip(label: '51–68 OK', color: AppColors.hard),
            const SizedBox(width: AppSpacing.xs),
            ThresholdChip(label: '68–80 Good', color: AppColors.easy),
            const SizedBox(width: AppSpacing.xs),
            ThresholdChip(label: '> 80 Excellent', color: AppColors.correct),
          ],
        ),
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
