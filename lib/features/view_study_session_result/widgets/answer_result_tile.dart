// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/drill_result/answer_result_tile.dart
// PURPOSE: List tile showing a single drill answer result with rating chip
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/features/app_theme/app_theme.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show StudyRating, AppTokens, AppColors, ThemeHelper;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class AnswerResultTile extends StatelessWidget {
  const AnswerResultTile({
    super.key,
    required this.userAnswer,
    required this.type, // <-- Replaced `isCorrect` and `selfRating`
    this.isEjected = false,
  });

  final String userAnswer;
  final StudyRating type; // <-- The clean enum
  final bool isEjected;

  // Helper to determine pass/fail for the leading icon
  bool get _isCorrect => type != StudyRating.incorrect;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final ratingColorSet = ThemeHelper.getStudyRatingColorSet(tokens, type);

    return Surface(
      style: surfaceStyle.resolve(tokens, const [
        SurfaceShape.roundedSm,
        SurfacePadding.sm,
        // SurfaceBorder.none,
      ]),
      child: ListTile(
        leading: Icon(
          _isCorrect ? Icons.check_circle : Icons.cancel,
          color: _isCorrect
              ? tokens.colorActionSuccess
              : tokens.colorActionError,
        ),
        title: Text(userAnswer.isEmpty ? '(no answer)' : userAnswer),
        trailing: isEjected
            ? Tooltip(
                message: 'This card was moved to FSRS review',
                child: Chip(
                  label: const Text('Review Later'),
                  backgroundColor: AppColors.hard.withValues(alpha: 0.12),
                  labelStyle: const TextStyle(
                    color: AppColors.hard,
                    fontSize: 11,
                  ),
                  side: BorderSide.none,
                  visualDensity: VisualDensity.compact,
                ),
              )
            // If it's correct (not a typo), show the FSRS rating they gave it
            : type != StudyRating.incorrect
            ? Chip(label: Text(ratingColorSet.name))
            : null,
      ),
    );
  }
}
