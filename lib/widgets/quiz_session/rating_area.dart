// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/rating_area.dart
// PURPOSE: Shared rating area shown after answering, with optional feedback
// PROVIDERS: QuizSessionPageController
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:fsrs/fsrs.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class RatingArea extends StatelessWidget {
  const RatingArea({
    super.key,
    required this.card,
    required this.controller,
    required this.answer,
  });

  final DeckCard card;
  final QuizSessionPageController controller;

  // Needed for logging
  final String answer;

  @override
  Widget build(BuildContext context) {
    void onTap(Rating r) {
      controller.submitAnswer(
        answer, // Placeholder string for manually rated cards
        QuizAnswer.fromRatingToType(r),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'How well did you know it?',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            RatingButton(Rating.again, onTap: () => onTap(Rating.again)),
            const SizedBox(width: AppSpacing.sm),
            RatingButton(Rating.hard, onTap: () => onTap(Rating.hard)),
            const SizedBox(width: AppSpacing.sm),
            RatingButton(Rating.good, onTap: () => onTap(Rating.good)),
            const SizedBox(width: AppSpacing.sm),
            RatingButton(Rating.easy, onTap: () => onTap(Rating.easy)),
          ],
        ),
      ],
    );
  }
}
