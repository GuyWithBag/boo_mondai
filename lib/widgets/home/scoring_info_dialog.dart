// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/home/scoring_info_dialog.dart
// PURPOSE: Dialog explaining how leaderboard scoring works
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class ScoringInfoDialog extends StatelessWidget {
  const ScoringInfoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('How scoring works'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ScoreRow(
            icon: Icons.quiz_outlined,
            label: 'Quiz score',
            detail: 'Total correct answers across all quiz sessions.',
          ),
          const SizedBox(height: AppSpacing.md),
          const ScoreRow(
            icon: Icons.replay_outlined,
            label: 'Review count',
            detail: 'Total FSRS spaced-repetition reviews completed.',
          ),
          const SizedBox(height: AppSpacing.md),
          const ScoreRow(
            icon: Icons.local_fire_department_outlined,
            label: 'Streak',
            detail: 'Consecutive days with at least one review.',
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Rankings are sorted by quiz score. Keep quizzing and reviewing '
            'every day to climb higher!',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Got it'),
        ),
      ],
    );
  }
}
