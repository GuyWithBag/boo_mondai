// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_result/score_reveal.dart
// PURPOSE: Animated score count-up with scale bounce for quiz results
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class ScoreReveal extends StatelessWidget {
  const ScoreReveal({
    super.key,
    required this.animation,
    required this.correct,
    required this.total,
    required this.percent,
  });

  final Animation<double> animation;
  final int correct;
  final int total;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final scale =
            1.0 + (1.2 - 1.0) * Curves.elasticOut.transform(animation.value);
        final displayCount = (correct * animation.value).round();
        return Transform.scale(
          scale: animation.value < 1.0 ? scale : 1.0,
          child: Column(
            children: [
              Text(
                '$displayCount / $total',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: percent >= 0.7
                      ? AppColors.correct
                      : percent >= 0.4
                      ? AppColors.hard
                      : AppColors.incorrect,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '${(percent * 100).round()}% correct',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        );
      },
    );
  }
}
