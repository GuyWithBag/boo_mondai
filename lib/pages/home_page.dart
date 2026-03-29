// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/home_page.dart
// PURPOSE: Dashboard — streak, due reviews, leaderboard preview
// PROVIDERS: AuthProvider, FsrsProvider, StreakProvider, LeaderboardProvider
// HOOKS: useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/providers/providers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final fsrs = context.watch<FsrsProvider>();
    final streakProv = context.watch<StreakProvider>();
    final leaderboard = context.watch<LeaderboardProvider>();
    final userId = auth.userProfile?.id;

    useEffect(() {
      if (userId != null) {
        Future.microtask(() {
          context.read<FsrsProvider>().fetchDueCards(userId);
          context.read<StreakProvider>().fetchStreak(userId);
          context.read<LeaderboardProvider>().fetchLeaderboard(
            targetLanguage: auth.userProfile?.targetLanguage,
          );
        });
      }
      return null;
    }, [userId]);

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (userId != null) {
              await Future.wait([
                context.read<FsrsProvider>().fetchDueCards(userId),
                context.read<StreakProvider>().fetchStreak(userId),
                context.read<LeaderboardProvider>().fetchLeaderboard(
                  targetLanguage: auth.userProfile?.targetLanguage,
                ),
              ]);
            }
          },
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Text(
                'Welcome, ${auth.userProfile?.displayName ?? 'Learner'}!',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              StreakBadge(currentStreak: streakProv.currentStreak),
              const SizedBox(height: AppSpacing.md),
              DueReviewCard(
                dueCount: fsrs.dueCount,
                onTap: () => context.go('/review'),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: () => context.go('/my-decks'),
                icon: const Icon(Icons.library_books),
                label: const Text('Browse Decks'),
              ),
              if (auth.role == 'researcher') ...[
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
                userId: userId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
