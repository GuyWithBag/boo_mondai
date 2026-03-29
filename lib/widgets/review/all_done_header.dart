// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/review/all_done_header.dart
// PURPOSE: Header row with check icon shown when all reviewable cards are done
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class AllDoneHeader extends StatelessWidget {
  const AllDoneHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check_circle, size: 28, color: AppColors.correct),
        const SizedBox(width: AppSpacing.sm),
        Text(
          "All caught up for now!",
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: AppColors.correct),
        ),
      ],
    );
  }
}
