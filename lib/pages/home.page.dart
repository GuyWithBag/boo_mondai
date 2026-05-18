// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/home_page.dart
// PURPOSE: Dashboard — streak, due reviews, leaderboard preview
// PROVIDERS: AuthController, StreakController, ViewReviewsController, ViewLeaderboardController
// HOOKS: useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/database/database.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

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
      appBar: AppBar(title: const Text('Home')),
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
              Text(
                'Welcome, ${auth.currentProfile.username}!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              StreakCard(streak: LocalDB.streak.retrieve()),
              const SizedBox(height: AppSpacing.md),
              DueReviewCard(
                dueCount: reviewDashboard.totalDue,
                onTap: () => context.push('/review/session'),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: () => context.go('/my-decks'),
                icon: const Icon(Icons.library_books),
                label: const Text('Browse Decks'),
              ),
              if (auth.currentProfile.role == 'researcher') ...[
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton.icon(
                  onPressed: () => context.push('/research'),
                  icon: const Icon(Icons.science),
                  label: const Text('Research Dashboard'),
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              LeaderboardSection(
                entries: leaderboard.entries.take(5).toList(),
                isLoading: leaderboard.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
