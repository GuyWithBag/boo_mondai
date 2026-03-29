// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_result/deck_review_row.dart
// PURPOSE: Row showing deck title with review-ready and review-later badges
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class DeckReviewRow extends StatelessWidget {
  const DeckReviewRow({
    super.key,
    required this.deckTitle,
    required this.reviewableNow,
    required this.reviewLater,
  });

  final String deckTitle;
  final int reviewableNow;
  final int reviewLater;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            deckTitle,
            style: Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        if (reviewableNow > 0)
          StatusBadge(label: '$reviewableNow ready', color: AppColors.correct),
        if (reviewableNow > 0 && reviewLater > 0) const SizedBox(width: 4),
        if (reviewLater > 0)
          Tooltip(
            message: 'These cards were moved to FSRS review',
            child: StatusBadge(
              label: '$reviewLater later',
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
  }
}
