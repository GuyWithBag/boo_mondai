// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/streak_badge.dart
// PURPOSE: Reusable streak display with fire icon and count
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show StreakFlamePainter, Streak, AppSpacing;
import 'package:flutter/material.dart';

class StreakCard extends StatelessWidget {
  final Streak? streak;
  final bool compact;

  const StreakCard({super.key, required this.streak, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final currentStreak = streak?.currentStreak ?? -1;
    if (compact) {
      return Tooltip(
        message: '$streak day streak',
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomPaint(
              size: const Size(18, 18),
              painter: StreakFlamePainter(streakCount: currentStreak),
            ),
            const SizedBox(width: 4),
            Text('$currentStreak'),
          ],
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            CustomPaint(
              size: const Size(40, 40),
              painter: StreakFlamePainter(streakCount: currentStreak),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$currentStreak day streak',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  currentStreak > 0
                      ? 'Keep it going!'
                      : 'Complete a review to start!',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
