// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/streak_badge.dart
// PURPOSE: Reusable streak display with fire icon and count
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/painters/painters.dart';
import 'package:boo_mondai/shared/shared.dart';

class StreakBadge extends StatelessWidget {
  final int currentStreak;
  final bool compact;

  const StreakBadge({
    super.key,
    required this.currentStreak,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Tooltip(
        message: '$currentStreak day streak',
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
