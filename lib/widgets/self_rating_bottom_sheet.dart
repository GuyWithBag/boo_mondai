// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/self_rating_bottom_sheet.dart
// PURPOSE: Reusable FSRS self-rating widget (Again/Hard/Good/Easy) for quiz and review
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/rating_button.dart';

class SelfRatingButtons extends StatelessWidget {
  final void Function(int rating) onRate;
  final String? promptText;

  const SelfRatingButtons({super.key, required this.onRate, this.promptText});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (promptText != null) ...[
          Text(promptText!, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.sm),
        ],
        Row(
          children: [
            RatingButton(
              label: 'Again',
              color: AppColors.incorrect,
              shortcut: '1',
              onTap: () => onRate(1),
            ),
            const SizedBox(width: AppSpacing.sm),
            RatingButton(
              label: 'Hard',
              color: AppColors.hard,
              shortcut: '2',
              onTap: () => onRate(2),
            ),
            const SizedBox(width: AppSpacing.sm),
            RatingButton(
              label: 'Good',
              color: AppColors.correct,
              shortcut: '3',
              onTap: () => onRate(3),
            ),
            const SizedBox(width: AppSpacing.sm),
            RatingButton(
              label: 'Easy',
              color: AppColors.easy,
              shortcut: '4',
              onTap: () => onRate(4),
            ),
          ],
        ),
      ],
    );
  }
}
