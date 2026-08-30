// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/drill_result/deck_review_row.dart
// PURPOSE: Row showing deck title with review-ready and review-later badges
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart' show HeaderBadge, AppTokens;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

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
    final tokens = context.themeTokens<AppTokens>();
    return Row(
      children: [
        Expanded(child: Text(deckTitle, overflow: TextOverflow.ellipsis)),
        SizedBox(width: tokens.spaceLayoutGapSm),
        if (reviewableNow > 0)
          HeaderBadge(
            label: '$reviewableNow ready',
            // color: AppColors.correct
          ),
        if (reviewableNow > 0 && reviewLater > 0) const SizedBox(width: 4),
        if (reviewLater > 0)
          Tooltip(
            message: 'These cards were moved to FSRS review',
            child: HeaderBadge(
              label: '$reviewLater later',
              // color: AppColors.colorTextSecondary,
            ),
          ),
      ],
    );
  }
}
