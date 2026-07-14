// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/deck_card_form_state.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        MultipleChoiceOptionData,
        CardType,
        QuestionType,
        MatchPairData,
        defaultMultipleChoiceOptions,
        defaultMatchPairs;
import 'package:flutter/material.dart';

class CardTemplateFormState {
  final ValueNotifier<QuestionType> questionType;
  final ValueNotifier<CardType> cardType;
  final ValueNotifier<bool> verticallyCentered;
  final TextEditingController frontController;
  final TextEditingController backController;
  final TextEditingController identificationAnswerController;
  final ValueNotifier<List<MultipleChoiceOptionData>> multipleChoiceOptions;
  final TextEditingController fillInTheBlankSentenceController;
  final TextEditingController fillInTheBlankAnswersController;
  final ValueNotifier<List<MatchPairData>> matchPairs;

  CardTemplateFormState({
    required this.questionType,
    required this.cardType,
    required this.verticallyCentered,
    required this.frontController,
    required this.backController,
    required this.identificationAnswerController,
    required this.multipleChoiceOptions,
    required this.fillInTheBlankSentenceController,
    required this.fillInTheBlankAnswersController,
    required this.matchPairs,
  });

  factory CardTemplateFormState.empty({
    QuestionType questionType = QuestionType.flashcard,
    CardType cardType = CardType.normal,
    bool verticallyCentered = true,
  }) {
    return CardTemplateFormState(
      questionType: ValueNotifier(questionType),
      cardType: ValueNotifier(cardType),
      verticallyCentered: ValueNotifier(verticallyCentered),
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
    verticallyCentered.dispose();
    frontController.dispose();
    backController.dispose();
    identificationAnswerController.dispose();
    multipleChoiceOptions.dispose();
    fillInTheBlankSentenceController.dispose();
    fillInTheBlankAnswersController.dispose();
    matchPairs.dispose();
  }
}
