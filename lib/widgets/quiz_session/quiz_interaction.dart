// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/quiz_interaction.dart
// PURPOSE: Dispatches to the correct interaction widget based on question type
// PROVIDERS: QuizSessionPageController
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class QuizInteraction extends StatelessWidget {
  const QuizInteraction({
    super.key,
    required this.card,
    required this.controller,
    required this.shakeController,
  });

  final DeckCard card;
  final QuizSessionPageController controller;
  final AnimationController shakeController;

  @override
  Widget build(BuildContext context) {
    if (controller.awaitingRating) {
      return RatingArea(card: card, controller: controller);
    }
    return switch (card.questionType) {
      QuestionType.flashcard => FlashcardInteraction(
        card: card,
        controller: controller,
      ),
      QuestionType.identification => IdentificationInteraction(
        card: card,
        controller: controller,
        shakeController: shakeController,
      ),
      QuestionType.multipleChoice => MultipleChoiceInteraction(
        card: card,
        controller: controller,
        shakeController: shakeController,
      ),
      QuestionType.fillInTheBlanks => FitbInteraction(
        card: card,
        controller: controller,
        shakeController: shakeController,
      ),
      QuestionType.wordScramble => WordScrambleInteraction(
        card: card,
        controller: controller,
        shakeController: shakeController,
      ),
      QuestionType.matchMadness => MatchMadnessInteraction(
        card: card,
        controller: controller,
      ),
    };
  }
}
