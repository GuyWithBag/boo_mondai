// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/rating_button.dart
// PURPOSE: Individual button for submitting an FSRS rating
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart'; // Needed for QuizAnswerType
import 'package:boo_mondai/shared/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RatingButton extends StatelessWidget {
  final QuizAnswerType type;
  final VoidCallback onTap;

  const RatingButton(this.type, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<QuizSessionPageController>();
    final reviewTime = ctrl.nextIntervals[type] ?? '-';

    late final String shortcut;
    late final Color color;
    late final String label;

    switch (type) {
      case QuizAnswerType.again:
      case QuizAnswerType.incorrect: // Fallback just in case
        label = 'Again';
        shortcut = '1';
        color = AppColors.incorrect;
      case QuizAnswerType.hard:
        label = 'Hard';
        shortcut = '2';
        color = AppColors.hard;
      case QuizAnswerType.good:
        label = 'Good';
        shortcut = '3';
        color = AppColors.correct;
      case QuizAnswerType.easy:
        label = 'Easy';
        shortcut = '4';
        color = AppColors.easy;
    }

    return Expanded(
      child: Tooltip(
        message: 'Press $shortcut',
        child: FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            backgroundColor: color.withValues(alpha: 0.15),
            foregroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                reviewTime,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
