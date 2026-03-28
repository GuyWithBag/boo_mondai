// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/researcher_dashboard/score_bar.dart
// PURPOSE: Reusable horizontal score bar with label, progress indicator, and value
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.dart';

class ScoreBar extends StatelessWidget {
  final String label;
  final double value;
  final double max;
  final Color? color;
  final String? valueLabel;

  const ScoreBar({
    super.key,
    required this.label,
    required this.value,
    required this.max,
    this.color,
    this.valueLabel,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = max == 0 ? 0.0 : (value / max).clamp(0.0, 1.0);
    final barColor = color ??
        (fraction >= 0.7 ? AppColors.correct : AppColors.hard);

    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 14,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              color: barColor,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          width: 64,
          child: Text(
            valueLabel ?? value.toStringAsFixed(1),
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
