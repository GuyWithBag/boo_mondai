// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/home_page.dart
// PURPOSE: Dashboard — streak, due reviews, recent activity
// PROVIDERS: AuthProvider, FsrsProvider, StreakProvider
// HOOKS: useEffect
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/auth_provider.dart';
import 'package:boo_mondai/providers/fsrs_provider.dart';
import 'package:boo_mondai/providers/streak_provider.dart';
import 'package:boo_mondai/shared/app_spacing.dart';
import 'package:boo_mondai/shared/theme_constants.dart';
import 'package:boo_mondai/widgets/streak_badge.dart';

class HomePage extends HookWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final fsrs = context.watch<FsrsProvider>();
    final streakProv = context.watch<StreakProvider>();
    final userId = auth.userProfile?.id;

    useEffect(() {
      if (userId != null) {
        Future.microtask(() {
          context.read<FsrsProvider>().fetchDueCards(userId);
          context.read<StreakProvider>().fetchStreak(userId);
        });
      }
      return null;
    }, [userId]);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          if (userId != null) {
            await Future.wait([
              context.read<FsrsProvider>().fetchDueCards(userId),
              context.read<StreakProvider>().fetchStreak(userId),
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
              onPressed: () => context.go('/decks'),
              icon: const Icon(Icons.library_books),
              label: const Text('Browse Decks'),
            ),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton.icon(
              onPressed: () => context.go('/leaderboard'),
              icon: const Icon(Icons.leaderboard),
              label: const Text('Leaderboard'),
            ),
            if (auth.role == 'researcher') ...[
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton.icon(
                onPressed: () => context.go('/research'),
                icon: const Icon(Icons.science),
                label: const Text('Research Dashboard'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class DueReviewCard extends StatelessWidget {
  final int dueCount;
  final VoidCallback onTap;
  const DueReviewCard({super.key, required this.dueCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primary,
      child: InkWell(
        onTap: dueCount > 0 ? onTap : null,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(Icons.replay, color: theme.colorScheme.onPrimary, size: 40),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$dueCount card${dueCount == 1 ? '' : 's'} due',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    Text(
                      dueCount > 0
                          ? 'Tap to start review'
                          : "You're all caught up!",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              if (dueCount > 0)
                Icon(Icons.arrow_forward,
                    color: theme.colorScheme.onPrimary),
            ],
          ),
        ),
      ),
    );
  }
}
