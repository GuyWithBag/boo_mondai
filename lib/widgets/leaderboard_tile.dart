// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/leaderboard_tile.dart
// PURPOSE: Reusable leaderboard entry tile with rank, name, score, streak
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/theme_constants.dart';
import 'package:boo_mondai/widgets/streak_badge.dart';

class LeaderboardTileWidget extends StatelessWidget {
  final int rank;
  final String displayName;
  final int quizScore;
  final int reviewCount;
  final int currentStreak;

  const LeaderboardTileWidget({
    super.key,
    required this.rank,
    required this.displayName,
    required this.quizScore,
    required this.reviewCount,
    required this.currentStreak,
  });

  @override
  Widget build(BuildContext context) {
    final isTop3 = rank <= 3;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isTop3
              ? AppColors.streakFire.withValues(alpha: 0.2)
              : null,
          child: Text(
            '$rank',
            style: TextStyle(
              fontWeight: isTop3 ? FontWeight.bold : FontWeight.normal,
              color: isTop3 ? AppColors.streakFire : null,
            ),
          ),
        ),
        title: Text(
          displayName,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          '$quizScore pts  ·  $reviewCount reviews',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: currentStreak > 0
            ? StreakBadge(currentStreak: currentStreak, compact: true)
            : null,
      ),
    );
  }
}
