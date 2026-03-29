// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/anki_counter.dart
// PURPOSE: Anki-style FSRS counter showing new, learning, and review counts
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class AnkiCounter extends StatelessWidget {
  const AnkiCounter({
    super.key,
    required this.newCount,
    required this.learningCount,
    required this.reviewCount,
  });

  final int newCount;
  final int learningCount;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StatusBadge(
          label: '$newCount',
          color: AppColors.easy,
          backgroundOpacity: 0.15,
        ),
        const SizedBox(width: AppSpacing.sm),
        StatusBadge(
          label: '$learningCount',
          color: AppColors.incorrect,
          backgroundOpacity: 0.15,
        ),
        const SizedBox(width: AppSpacing.sm),
        StatusBadge(
          label: '$reviewCount',
          color: AppColors.correct,
          backgroundOpacity: 0.15,
        ),
      ],
    );
  }
}
