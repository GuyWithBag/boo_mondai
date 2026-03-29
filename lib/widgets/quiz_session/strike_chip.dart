// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/strike_chip.dart
// PURPOSE: Chip displaying current attempt number out of max strikes
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class StrikeChip extends StatelessWidget {
  const StrikeChip({super.key, required this.strikes, required this.max});

  final int strikes;
  final int max;

  @override
  Widget build(BuildContext context) {
    final isLast = strikes >= max - 1;
    final color = isLast ? AppColors.incorrect : AppColors.hard;
    return Chip(
      label: Text('Attempt ${strikes + 1} / $max'),
      labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: color,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: color.withValues(alpha: 0.12),
      side: BorderSide(color: color.withValues(alpha: 0.4)),
      visualDensity: VisualDensity.compact,
    );
  }
}
