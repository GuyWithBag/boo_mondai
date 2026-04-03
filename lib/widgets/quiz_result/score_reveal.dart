// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/score_reveal.dart
// PURPOSE: Animated breakdown of quiz performance by FSRS rating
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class ScoreReveal extends StatelessWidget {
  const ScoreReveal({
    super.key,
    required this.animation,
    required this.breakdown,
    required this.total,
  });

  final Animation<double> animation;
  final Map<QuizAnswerType, int> breakdown;
  final int total;

  String _getLabel(QuizAnswerType type) {
    return switch (type) {
      QuizAnswerType.again => 'Again',
      QuizAnswerType.hard => 'Hard',
      QuizAnswerType.good => 'Good',
      QuizAnswerType.easy => 'Easy',
      QuizAnswerType.incorrect => 'Incorrect',
    };
  }

  Color _getColor(QuizAnswerType type) {
    return switch (type) {
      QuizAnswerType.incorrect => AppColors.incorrect,
      QuizAnswerType.again => AppColors.incorrect,
      QuizAnswerType.hard => AppColors.hard,
      QuizAnswerType.good => AppColors.correct,
      QuizAnswerType.easy => AppColors.correct,
    };
  }

  @override
  Widget build(BuildContext context) {
    // Determine the order we want to display them in
    const displayOrder = [
      QuizAnswerType.incorrect,
      QuizAnswerType.again,
      QuizAnswerType.hard,
      QuizAnswerType.good,
      QuizAnswerType.easy,
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
