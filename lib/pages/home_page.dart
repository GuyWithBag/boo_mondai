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
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/shared/shared.dart';
import 'package:boo_mondai/widgets/widgets.dart';

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
              _LeaderboardSection(
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

class _LeaderboardSection extends StatelessWidget {
  const _LeaderboardSection({
    required this.entries,
    required this.isLoading,
    required this.userId,
  });

  final List<LeaderboardEntry> entries;
  final bool isLoading;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Leaderboard',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            IconButton(
              icon: const Icon(Icons.info_outline, size: 18),
              tooltip: 'How scoring works',
              color: AppColors.textSecondary,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => const _ScoringInfoDialog(),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => context.push('/leaderboard'),
              child: const Text('See All'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (entries.isEmpty)
          Text(
            'No scores yet — complete a quiz to appear here!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          )
        else
          ...entries.asMap().entries.map(
            (e) => LeaderboardTileWidget(
              rank: e.key + 1,
              displayName: e.value.displayName,
              quizScore: e.value.quizScore,
              reviewCount: e.value.reviewCount,
              currentStreak: e.value.currentStreak,
            ),
          ),
      ],
    );
  }
}

// ── Scoring info dialog ───────────────────────────────────────────

class _ScoringInfoDialog extends StatelessWidget {
  const _ScoringInfoDialog();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('How scoring works'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ScoreRow(
            icon: Icons.quiz_outlined,
            label: 'Quiz score',
            detail: 'Total correct answers across all quiz sessions.',
          ),
          const SizedBox(height: AppSpacing.md),
          _ScoreRow(
            icon: Icons.replay_outlined,
            label: 'Review count',
            detail: 'Total FSRS spaced-repetition reviews completed.',
          ),
          const SizedBox(height: AppSpacing.md),
          _ScoreRow(
            icon: Icons.local_fire_department_outlined,
            label: 'Streak',
            detail: 'Consecutive days with at least one review.',
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Rankings are sorted by quiz score. Keep quizzing and reviewing '
            'every day to climb higher!',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Got it'),
        ),
      ],
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({
    required this.icon,
    required this.label,
    required this.detail,
  });

  final IconData icon;
  final String label;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              Text(detail,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Due review card ───────────────────────────────────────────────

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
                        color: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (dueCount > 0)
                Icon(Icons.arrow_forward, color: theme.colorScheme.onPrimary),
            ],
          ),
        ),
      ),
    );
  }
}
