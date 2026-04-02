// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/rating_button.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/shared/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fsrs/fsrs.dart';

class RatingButton extends StatelessWidget {
  final Rating rating;
  final VoidCallback onTap;

  // We no longer need to pass the string in the constructor!
  const RatingButton(this.rating, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // 1. Connect directly to the controller
    final ctrl = context.watch<QuizSessionPageController>();

    // 2. Grab the pre-calculated time for this specific rating (fallback to '-' if loading)
    final reviewTime = ctrl.nextIntervals[rating] ?? '-';

    late final String shortcut;
    late final Color color;
    late final String label;

    switch (rating) {
      case Rating.again:
        label = 'Again';
        shortcut = '1';
        color = AppColors.incorrect;
      case Rating.hard:
        label = 'Hard';
        shortcut = '2';
        color = AppColors.hard;
      case Rating.good:
        label = 'Good';
        shortcut = '3';
        color = AppColors.correct;
      case Rating.easy:
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
                reviewTime, // 3. Display the controller's time
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
