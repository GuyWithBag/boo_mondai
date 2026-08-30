// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/deck_card_form_state.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        MultipleChoiceOption,
        CardType,
        QuestionType,
        IdentificationAnswerData,
        MatchPairData,
        defaultIdentificationAnswers,
        defaultMatchPairs;
import 'package:flutter/material.dart';

class CardTemplateFormState {
  final ValueNotifier<QuestionType> questionType;
  final ValueNotifier<CardType> cardType;
  final ValueNotifier<bool> verticallyCentered;
  final TextEditingController frontController;
  final TextEditingController backController;
  final ValueNotifier<List<IdentificationAnswerData>> identificationAnswers;
  final ValueNotifier<List<MultipleChoiceOption>> multipleChoiceOptions;
  final TextEditingController fillInTheBlankSentenceController;
  final TextEditingController fillInTheBlankAnswersController;
  final ValueNotifier<List<MatchPairData>> matchPairs;

  CardTemplateFormState({
    required this.questionType,
    required this.cardType,
    required this.verticallyCentered,
    required this.frontController,
    required this.backController,
    required this.identificationAnswers,
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
      identificationAnswers: ValueNotifier([...defaultIdentificationAnswers]),
      fillInTheBlankSentenceController: TextEditingController(),
      fillInTheBlankAnswersController: TextEditingController(),
      multipleChoiceOptions: ValueNotifier(const []),
      matchPairs: ValueNotifier([...defaultMatchPairs]),
    );
  }

  void dispose() {
    questionType.dispose();
    cardType.dispose();
    verticallyCentered.dispose();
    frontController.dispose();
    backController.dispose();
    identificationAnswers.dispose();
    multipleChoiceOptions.dispose();
    fillInTheBlankSentenceController.dispose();
    fillInTheBlankAnswersController.dispose();
    matchPairs.dispose();
  }
}
