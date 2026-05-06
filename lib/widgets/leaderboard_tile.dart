// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/leaderboard_tile.dart
// PURPOSE: Reusable leaderboard entry tile with rank, name, score, streak
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:flutter/material.dart';
import 'package:boo_mondai/widgets/streak_badge.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LeaderboardTileWidget extends HookWidget {
  final int rank;
  final LeaderboardEntry entry;

  const LeaderboardTileWidget({
    super.key,
    required this.rank,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    final isTop3 = rank <= 3;

    final dataFuture =
        useMemoized<Future<({Profile? profile, Streak? streak})>>(() async {
          final results = await Future.wait([
            RemoteDB.profile.selectByUserId(entry.userId),
            RemoteDB.streak.selectByUserId(entry.userId),
          ]);
          return (
            profile: results[0] as Profile?,
            streak: results[1] as Streak?,
          );
        }, [entry.userId]);

    final snapshot = useFuture(dataFuture);
    final isLoading = !snapshot.hasData && !snapshot.hasError;
    final profile = snapshot.data?.profile;
    final streak = snapshot.data?.streak;

    return Skeletonizer(
      enabled: isLoading,
      child: Card(
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
            profile?.username ?? 'Loading...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            '${entry.drillScore} pts  ·  ${entry.reviewCount} reviews',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: streak != null && streak.currentStreak > 0
              ? StreakBadge(streak: streak, compact: true)
              : null,
        ),
      ),
    );
  }
}
