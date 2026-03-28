// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_session/quiz_interaction.dart
// PURPOSE: Dispatches to the correct interaction widget based on question type
// PROVIDERS: QuizProvider
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/pages/quiz_session/rating_area.dart';
import 'package:boo_mondai/pages/quiz_session/flashcard_interaction.dart';
import 'package:boo_mondai/pages/quiz_session/identification_interaction.dart';
import 'package:boo_mondai/pages/quiz_session/multiple_choice_interaction.dart';
import 'package:boo_mondai/pages/quiz_session/fitb_interaction.dart';
import 'package:boo_mondai/pages/quiz_session/word_scramble_interaction.dart';
import 'package:boo_mondai/pages/quiz_session/match_madness_interaction.dart';

class QuizInteraction extends StatelessWidget {
  const QuizInteraction({
    super.key,
    required this.card,
    required this.quiz,
    required this.shakeController,
  });

  final DeckCard card;
  final QuizProvider quiz;
  final AnimationController shakeController;

  @override
  Widget build(BuildContext context) {
    if (quiz.awaitingRating) {
      return RatingArea(card: card, quiz: quiz);
    }
    return switch (card.questionType) {
      QuestionType.flashcard => FlashcardInteraction(
          card: card, quiz: quiz),
      QuestionType.identification => IdentificationInteraction(
          card: card, quiz: quiz, shakeController: shakeController),
      QuestionType.multipleChoice => MultipleChoiceInteraction(
          card: card, quiz: quiz, shakeController: shakeController),
      QuestionType.fillInTheBlanks => FitbInteraction(
          card: card, quiz: quiz, shakeController: shakeController),
      QuestionType.wordScramble => WordScrambleInteraction(
          card: card, quiz: quiz, shakeController: shakeController),
      QuestionType.matchMadness => MatchMadnessInteraction(
          card: card, quiz: quiz),
    };
  }
}
