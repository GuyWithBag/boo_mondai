// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/leaderboard_tile.dart
// PURPOSE: Reusable leaderboard entry tile with rank, medal, score, streak
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        LeaderboardEntry,
        RemoteDB,
        Streak,
        SurfaceBorder,
        SurfaceShape,
        SurfaceTone,
        surfaceStyle;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:theme_variants/theme_variants.dart';

class LeaderboardTileWidget extends HookWidget {
  final int rank;
  final LeaderboardEntry entry;
  final bool isCurrentUser;

  const LeaderboardTileWidget({
    super.key,
    required this.rank,
    required this.entry,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final medal = _RankMedal.forRank(rank);
    final tileVariants = isCurrentUser
        ? const [SurfaceShape.cardShape, SurfaceTone.primaryOutline]
        : const [SurfaceTone.muted, SurfaceShape.cardShape, SurfaceBorder.none];

    final streakFuture = useMemoized<Future<Streak?>>(
      () => RemoteDB.streak.selectOne(filters: {'user_id': entry.userId}),
      [entry.userId],
    );

    final snapshot = useFuture(streakFuture);
    final isLoading = !snapshot.hasData && !snapshot.hasError;
    final streak = snapshot.data;
    final profile = entry.userProfile;
    final name = profile?.username ?? 'Unknown user';

    return Skeletonizer(
      enabled: isLoading,
      child: Surface(
        style: surfaceStyle.resolve(tokens, tileVariants),
        child: Row(
          children: [
            SizedBox(
              width: 28.w,
              child: Text(
                '$rank',
                style: TextStyle(
                  fontSize: tokens.textSizeLabelLarge.sp,
                  fontWeight: tokens.fontWeightTextHeavy,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Icon(medal.icon, color: medal.color, size: 28.sp),
            SizedBox(width: 12.w),
            CircleAvatar(
              radius: 16.r,
              backgroundColor: tokens.primarySoft,
              backgroundImage: profile?.avatarUrl == null
                  ? null
                  : NetworkImage(profile!.avatarUrl!),
              child: profile?.avatarUrl == null
                  ? Icon(
                      Icons.person_outline,
                      color: tokens.primary,
                      size: 20.sp,
                    )
                  : null,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isCurrentUser ? '$name (You)' : name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: tokens.textSizeLabelLarge.sp,
                      fontWeight: tokens.fontWeightTextHeavy,
                      color: tokens.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${entry.drillScore} points  ${entry.reviewCount} reviews',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: tokens.textSizeLabelSmall.sp,
                      fontWeight: tokens.fontWeightTextStrong,
                      color: tokens.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              '${streak?.currentStreak ?? 0}',
              style: TextStyle(
                fontSize: tokens.textSizeLabelLarge.sp,
                fontWeight: tokens.fontWeightTextHeavy,
                color: tokens.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RankMedal {
  const _RankMedal({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  static _RankMedal forRank(int rank) {
    return switch (rank) {
      1 => const _RankMedal(
        icon: Icons.diamond_outlined,
        color: Color(0xFF38BDF8),
      ),
      2 => const _RankMedal(
        icon: Icons.workspace_premium_outlined,
        color: Color(0xFFF59E0B),
      ),
      3 => const _RankMedal(
        icon: Icons.workspace_premium_outlined,
        color: Color(0xFF94A3B8),
      ),
      4 => const _RankMedal(
        icon: Icons.workspace_premium_outlined,
        color: Color(0xFFB45309),
      ),
      _ => const _RankMedal(
        icon: Icons.workspace_premium_outlined,
        color: Colors.transparent,
      ),
    };
  }
}
