// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/deck_card_form_state.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:flutter/material.dart';

class DeckCardFormState {
  final ValueNotifier<QuestionType> questionType;
  final ValueNotifier<CardType> cardType;
  final TextEditingController frontController;
  final TextEditingController backController;
  final TextEditingController identificationAnswerController;
  final ValueNotifier<List<MultipleChoiceOptionData>> multipleChoiceOptions;
  final TextEditingController fillInTheBlankSentenceController;
  final TextEditingController fillInTheBlankAnswersController;
  final ValueNotifier<List<MatchPairData>> matchPairs;

  DeckCardFormState({
    required this.questionType,
    required this.cardType,
    required this.frontController,
    required this.backController,
    required this.identificationAnswerController,
    required this.multipleChoiceOptions,
    required this.fillInTheBlankSentenceController,
    required this.fillInTheBlankAnswersController,
    required this.matchPairs,
  });

  factory DeckCardFormState.empty({
    QuestionType questionType = QuestionType.flashcard,
    CardType cardType = CardType.normal,
  }) {
    return DeckCardFormState(
      questionType: ValueNotifier(questionType),
      cardType: ValueNotifier(cardType),
      frontController: TextEditingController(),
      backController: TextEditingController(),
      identificationAnswerController: TextEditingController(),
      fillInTheBlankSentenceController: TextEditingController(),
      fillInTheBlankAnswersController: TextEditingController(),
      // Assumes these defaults exist in your types
      multipleChoiceOptions: ValueNotifier([...defaultMultipleChoiceOptions]),
      matchPairs: ValueNotifier([...defaultMatchPairs]),
    );
  }

  void dispose() {
    questionType.dispose();
    cardType.dispose();
    frontController.dispose();
    backController.dispose();
    identificationAnswerController.dispose();
    multipleChoiceOptions.dispose();
    fillInTheBlankSentenceController.dispose();
    fillInTheBlankAnswersController.dispose();
    matchPairs.dispose();
  }
}
