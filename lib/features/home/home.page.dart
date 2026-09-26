// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/home_page.dart
// PURPOSE: Dashboard — streak, due reviews, leaderboard preview
// PROVIDERS: AuthController, StreakController, ViewStudyDecksController, ViewLeaderboardController
// HOOKS: useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        AuthController,
        LeaderboardSection,
        LocalDB,
        ReadyToReviewCard,
        Scaffold,
        StreaksCard,
        NotificationButton,
        ViewLeaderboardController,
        ViewStudyDecksController;
import 'package:flutter/material.dart' hide Scaffold, AppBar;
import 'package:flutter_hooks/flutter_hooks.dart' show useEffect, useMemoized;
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:provider/provider.dart' show ReadContext;
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart' show ThemeVariantsContext;

class HomePage extends SignalHookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthController>();
    final reviewDashboard = useMemoized(() => ViewStudyDecksController());
    final leaderboard = useMemoized(() => ViewLeaderboardController());
    final tokens = context.themeTokens<AppTokens>();
    final totalDue = reviewDashboard.totalDue.value;

    useEffect(() {
      Future.microtask(() {
        reviewDashboard.load();
        leaderboard.load();
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(title: 'Home', actions: const [NotificationButton()]),
      scrollable: true,
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([reviewDashboard.load(), leaderboard.load()]);
        },

        child: Column(
          spacing: tokens.spaceLayoutGapMd,
          children: [
            ReadyToReviewCard(
              dueCount: totalDue,
              onStartSession: () => context.push('/review/session'),
            ),
            StreaksCard(streak: LocalDB.streak.getOrCreate()),
            LeaderboardSection(
              entries: leaderboard.entries,
              isLoading: leaderboard.isLoading.value,
              currentUserId: auth.currentProfile.value.id,
            ),
          ],
        ),
      ),
    );
  }
}
