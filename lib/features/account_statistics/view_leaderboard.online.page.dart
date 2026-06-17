// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/leaderboard_page.dart
// PURPOSE: Display global leaderboard rankings with optional language filter
// PROVIDERS: ViewLeaderboardController
// HOOKS: useEffect, useScrollController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        AuthController,
        LeaderboardTileWidget,
        SurfaceBorder,
        SurfaceShape,
        SurfaceColor,
        ViewLeaderboardController,
        surfaceStyle;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewLeaderboardPage extends HookWidget {
  const ViewLeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final leaderboard = context.watch<ViewLeaderboardController>();
    final auth = context.watch<AuthController>();
    final tokens = context.themeTokens<AppTokens>();
    final scrollController = useScrollController();

    useEffect(() {
      Future.microtask(() => leaderboard.fetchLeaderboard());
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: leaderboard.isLoading
          ? const Center(child: CircularProgressIndicator())
          : leaderboard.entries.isEmpty
          ? const Center(child: Text('No entries yet'))
          : RefreshIndicator(
              onRefresh: () => leaderboard.fetchLeaderboard(),
              child: ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.all(16.r),
                itemCount: leaderboard.entries.length + 1,
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: Surface(
                        style: surfaceStyle.resolve(tokens, const [
                          SurfaceColor.baseline,
                          SurfaceShape.rounded,
                          SurfaceBorder.none,
                        ]),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rankings',
                                    style: TextStyle(
                                      fontSize: 24.sp,
                                      fontWeight: tokens.fontWeightTextHeavy,
                                      color: tokens.colorTextBaseline,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Sorted by drill score. Streaks are shown on the right.',
                                    style: TextStyle(
                                      fontSize: tokens.textSizeLabel.sp,
                                      fontWeight: tokens.fontWeightTextStrong,
                                      color: tokens.colorTextSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.workspace_premium_outlined,
                              size: 34.sp,
                              color: tokens.colorTextBaseline,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final entry = leaderboard.entries[i - 1];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: LeaderboardTileWidget(
                      rank: i,
                      entry: entry,
                      isCurrentUser: entry.userId == auth.currentProfile.id,
                    ),
                  );
                },
              ),
            ),
    );
  }
}
