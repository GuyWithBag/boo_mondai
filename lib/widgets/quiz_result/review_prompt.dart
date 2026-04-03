// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_result/review_prompt.dart
// PURPOSE: Card prompting user to review FSRS-enrolled cards after quiz
// PROVIDERS: DeckProvider
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class ReviewPrompt extends StatelessWidget {
  const ReviewPrompt({
    super.key,
    required this.deckId,
    required this.reviewableNow,
    required this.reviewLater,
    required this.onReviewNow,
    required this.onMaybeLater,
  });

  final String deckId;
  final int reviewableNow;
  final int reviewLater;
  final VoidCallback? onReviewNow;
  final VoidCallback onMaybeLater;

  @override
  Widget build(BuildContext context) {
    final deckProvider = Repositories.deck;

    // Safely look up the deck across both public and user decks
    final deck = [
      ...deckProvider.getAll(),
      ...deckProvider.getByCurrentUser(),
    ].where((d) => d.id == deckId).firstOrNull;

    final deckTitle = deck?.title ?? 'Your deck';

    // Check if the button is disabled to show a helpful tooltip
    final isReviewDisabled = onReviewNow == null;

    return Card(
      elevation: 0,
      color: AppColors.primary.withValues(alpha: 0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md),
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.schedule, size: 18, color: AppColors.primary),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Cards enrolled in FSRS',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            DeckReviewRow(
              deckTitle: deckTitle,
              reviewableNow: reviewableNow,
              reviewLater: reviewLater,
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onMaybeLater,
                    child: const Text('Maybe Later'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Tooltip(
                    message: isReviewDisabled
                        ? 'Cards need time to settle before their first review.'
                        : 'Start your spaced repetition review.',
                    child: FilledButton.icon(
                      onPressed: onReviewNow,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Review Now'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
