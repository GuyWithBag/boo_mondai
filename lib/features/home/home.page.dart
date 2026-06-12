// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/home_page.dart
// PURPOSE: Dashboard — streak, due reviews, leaderboard preview
// PROVIDERS: AuthController, StreakController, ViewReviewsController, ViewLeaderboardController
// HOOKS: useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AuthController,
        ViewReviewsController,
        ViewLeaderboardController,
        AppSpacing,
        LocalDB,
        LeaderboardSection,
        ReadyToReviewCard,
        StreaksCard;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final reviewDashboard = context.watch<ViewReviewsController>();
    final leaderboard = context.watch<ViewLeaderboardController>();

    useEffect(() {
      Future.microtask(() {
        reviewDashboard.load();
        leaderboard.fetchLeaderboard();
      });
      return null;
    }, []);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              reviewDashboard.load(),
              leaderboard.fetchLeaderboard(),
            ]);
          },
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              ReadyToReviewCard(
                dueCount: reviewDashboard.totalDue,
                onStartSession: () => context.push('/review/session'),
              ),
              const SizedBox(height: AppSpacing.md),
              StreaksCard(streak: LocalDB.streak.retrieve()),
              const SizedBox(height: AppSpacing.md),
              LeaderboardSection(
                entries: leaderboard.entries,
                isLoading: leaderboard.isLoading,
                currentUserId: auth.currentProfile.id,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
