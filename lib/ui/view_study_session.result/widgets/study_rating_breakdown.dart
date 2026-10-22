// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/study_rating_breakdown.dart
// PURPOSE: Animated breakdown of drill performance by FSRS rating
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/features/app_theme/app_theme.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, StudyRating, ThemeHelper;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class StudyRatingBreakdown extends StatelessWidget {
  const StudyRatingBreakdown({
    super.key,
    required this.animation,
    required this.breakdown,
    required this.total,
  });

  final Animation<double> animation;
  final Map<StudyRating, int> breakdown;
  final int total;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final labelStyle = textStyle.resolve(tokens, const [
      TextSize.label,
      TextWeight.strong,
    ]);
    final statStyle = textStyle.resolve(tokens, const [
      TextSize.labelSmall,
      TextColor.muted,
    ]);

    // Determine the order we want to display them in
    const displayOrder = [
      StudyRating.incorrect,
      StudyRating.again,
      StudyRating.hard,
      StudyRating.good,
      StudyRating.easy,
    ];

    if (total == 0) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: tokens.spaceLayoutGapSm.h,
      children: displayOrder.map((type) {
        final count = breakdown[type] ?? 0;

        // Hide rows with 0 answers to keep the UI clean
        if (count == 0) return const SizedBox.shrink();

        final percent = count / total;
        final colorSet = ThemeHelper.getStudyRatingColorSet(tokens, type);

        return Row(
          spacing: tokens.spaceLayoutGapSm,
          children: [
            Text(
              colorSet.name,
              style: labelStyle.copyWith(color: colorSet.colorText),
            ),

            Expanded(
              child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(
                      tokens.radiusSurfaceXsm.r,
                    ),
                    child: LinearProgressIndicator(
                      value: percent * animation.value,
                      backgroundColor: colorSet.colorBackground,
                      color: colorSet.colorBorder,
                      minHeight: tokens.spaceLayoutGapSm.h,
                    ),
                  );
                },
              ),
            ),

            // Stats Text (e.g. "1/3  (33%)")
            Text(
              '$count/$total  (${(percent * 100).round()}%)',
              textAlign: TextAlign.right,
              style: statStyle,
            ),
          ],
        );
      }).toList(),
    );
  }
}
