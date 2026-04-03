// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/home/leaderboard_section.dart
// PURPOSE: Home page leaderboard preview with top 5 entries
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class LeaderboardSection extends StatelessWidget {
  const LeaderboardSection({
    super.key,
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
                builder: (_) => const ScoringInfoDialog(),
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
              userName: e.value.userName,
              quizScore: e.value.quizScore,
              reviewCount: e.value.reviewCount,
              currentStreak: e.value.currentStreak,
            ),
          ),
      ],
    );
  }
}
