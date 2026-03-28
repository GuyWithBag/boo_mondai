// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/flashcard_answer.dart
// PURPOSE: Displays the correct answer for a flashcard question type
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/shared/shared.dart';

class FlashcardAnswer extends StatelessWidget {
  const FlashcardAnswer({super.key, required this.card});
  final DeckCard card;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.correct.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Text(
          card.answer,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: AppColors.correct),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
