// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/home_page.dart
// PURPOSE: Dashboard — streak, due reviews, leaderboard preview
// PROVIDERS: AuthController, StreakController, ViewReviewsController, ViewLeaderboardController
// HOOKS: useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        AuthController,
        LeaderboardSection,
        LocalDB,
        MainController,
        ReadyToReviewCard,
        Scaffold,
        StreaksCard,
        ViewLeaderboardController,
        ViewReviewsController;
import 'package:flutter/material.dart'
    show
        BuildContext,
        Widget,
        Column,
        RefreshIndicator,
        Expanded,
        SizedBox,
        Colors,
        Container;
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget, useEffect;
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:provider/provider.dart' show WatchContext, ReadContext;
import 'package:theme_variants/theme_variants.dart' show ThemeVariantsContext;

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final reviewDashboard = context.watch<ViewReviewsController>();
    final leaderboard = context.watch<ViewLeaderboardController>();
    final tokens = context.themeTokens<AppTokens>();

    useEffect(() {
      Future.microtask(() {
        reviewDashboard.load();
        leaderboard.fetchLeaderboard();
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(title: 'Home'),
      scrollable: true,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            reviewDashboard.load(),
            leaderboard.fetchLeaderboard(),
          ]);
        },

        child: Column(
          spacing: tokens.spaceLayoutGapMd,
          children: [
            ReadyToReviewCard(
              dueCount: reviewDashboard.totalDue,
              onStartSession: () => context.push('/review/session'),
            ),
            StreaksCard(streak: LocalDB.streak.getOrCreate()),
            LeaderboardSection(
              entries: leaderboard.entries,
              isLoading: leaderboard.isLoading,
              currentUserId: auth.currentProfile.id,
            ),
          ],
        ),
      ),
    );
  }
}
