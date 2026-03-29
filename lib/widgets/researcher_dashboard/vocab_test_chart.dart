// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/researcher_dashboard/vocab_test_chart.dart
// PURPOSE: Vocabulary test score histogram with average score bar
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class VocabTestChart extends StatelessWidget {
  final List<VocabularyTestResult> results;
  final int maxScore;

  const VocabTestChart({
    super.key,
    required this.results,
    required this.maxScore,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return EmptyChart(label: 'No submissions yet (0–$maxScore)');
    }

    final avg =
        results.map((r) => r.score).reduce((a, b) => a + b) / results.length;

    // Build buckets: 0–9, 10–19, 20–24, 25–29, 30
    final buckets = [
      ('0–9', results.where((r) => r.score <= 9).length),
      ('10–19', results.where((r) => r.score >= 10 && r.score <= 19).length),
      ('20–24', results.where((r) => r.score >= 20 && r.score <= 24).length),
      ('25–29', results.where((r) => r.score >= 25 && r.score <= 29).length),
      ('30', results.where((r) => r.score == 30).length),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScoreBar(
          label: 'Avg score',
          value: avg,
          max: maxScore.toDouble(),
          color: avg / maxScore >= 0.7 ? AppColors.correct : AppColors.hard,
          valueLabel: '${avg.toStringAsFixed(1)} / $maxScore',
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Distribution',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        BarHistogram(buckets: buckets),
      ],
    );
  }
}
