// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/review_dashboard/review_deck_tile.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/models/deck_review_stats.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class ReviewDeckTile extends StatelessWidget {
  const ReviewDeckTile({super.key, required this.stats, required this.onTap});

  final DeckReviewStats stats;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: stats.totalDue > 0 ? onTap : null, // Disable if nothing is due
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header: Title & Total Due ─────────────
              Row(
                children: [
                  Expanded(
                    child: Text(
                      stats.deckTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (stats.totalDue > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${stats.totalDue} Due',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    )
                  else
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.correct,
                      size: 20,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // ── Middle: Classic Anki Due Counts ──────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatColumn(
                    label: 'New',
                    count: stats.dueNew,
                    color: Colors.blue,
                  ),
                  _StatColumn(
                    label: 'Learn',
                    count: stats.dueLearning,
                    color: AppColors.incorrect,
                  ),
                  _StatColumn(
                    label: 'Review',
                    count: stats.dueReview,
                    color: AppColors.correct,
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.md),
              const Divider(height: 1),
              const SizedBox(height: AppSpacing.sm),

              // ── Bottom: Historical FSRS Ratings ──────────
              Text(
                'Historical Performance',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _HistoryBadge(
                    label: 'Again',
                    count: stats.historicalAgain,
                    color: AppColors.incorrect,
                  ),
                  _HistoryBadge(
                    label: 'Hard',
                    count: stats.historicalHard,
                    color: AppColors.hard,
                  ),
                  _HistoryBadge(
                    label: 'Good',
                    count: stats.historicalGood,
                    color: AppColors.correct,
                  ),
                  _HistoryBadge(
                    label: 'Easy',
                    count: stats.historicalEasy,
                    color: Colors.blue,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helper Widgets for the Tile ──────────────────────────────

class _StatColumn extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatColumn({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: count > 0
                ? color
                : AppColors.textSecondary.withValues(alpha: 0.5),
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _HistoryBadge extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _HistoryBadge({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.circle,
          size: 8,
          color: count > 0
              ? color
              : AppColors.textSecondary.withValues(alpha: 0.3),
        ),
        const SizedBox(width: 4),
        Text(
          '$label: $count',
          style: TextStyle(
            fontSize: 12,
            color: count > 0
                ? AppColors.textPrimary
                : AppColors.textSecondary.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}
