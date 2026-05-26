// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/score_reveal.dart
// PURPOSE: Animated breakdown of drill performance by FSRS rating
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart' show StudyRating, AppColors, AppSpacing;
import 'package:flutter/material.dart';

class ScoreReveal extends StatelessWidget {
  const ScoreReveal({
    super.key,
    required this.animation,
    required this.breakdown,
    required this.total,
  });

  final Animation<double> animation;
  final Map<StudyRating, int> breakdown;
  final int total;

  String _getLabel(StudyRating type) {
    return switch (type) {
      StudyRating.again => 'Again',
      StudyRating.hard => 'Hard',
      StudyRating.good => 'Good',
      StudyRating.easy => 'Easy',
      StudyRating.incorrect => 'Incorrect',
    };
  }

  Color _getColor(StudyRating type) {
    return switch (type) {
      StudyRating.incorrect => AppColors.incorrect,
      StudyRating.again => AppColors.incorrect,
      StudyRating.hard => AppColors.hard,
      StudyRating.good => AppColors.correct,
      StudyRating.easy => AppColors.correct,
    };
  }

  @override
  Widget build(BuildContext context) {
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
      children: displayOrder.map((type) {
        final count = breakdown[type] ?? 0;

        // Hide rows with 0 answers to keep the UI clean
        if (count == 0) return const SizedBox.shrink();

        final percent = count / total;
        final color = _getColor(type);

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: Row(
            children: [
              // Label
              SizedBox(
                width: 80,
                child: Text(
                  _getLabel(type),
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
              ),

              // Animated Progress Bar
              Expanded(
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percent * animation.value,
                        backgroundColor: color.withValues(alpha: 0.15),
                        color: color,
                        minHeight: 8,
                      ),
                    );
                  },
                ),
              ),

              // Stats Text (e.g. "1/3  (33%)")
              SizedBox(
                width: 80,
                child: Text(
                  '$count/$total  (${(percent * 100).round()}%)',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
