// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/rating_area.dart
// PURPOSE: Shared rating area shown after answering, with optional feedback
// PROVIDERS: QuizProvider
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/providers/providers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class RatingArea extends StatelessWidget {
  const RatingArea({super.key, required this.card, required this.quiz});

  final DeckCard card;
  final QuizProvider quiz;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (card.questionType == QuestionType.identification) ...[
          IdentificationFeedback(card: card, quiz: quiz),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (card.questionType == QuestionType.flashcard)
          FlashcardAnswer(card: card),
        SelfRatingButtons(
          promptText: 'How well did you know it?',
          onRate: (r) => context.read<QuizProvider>().submitSelfRating(r),
        ),
      ],
    );
  }
}
