import 'package:boo_mondai/lib.barrel.dart'
    show CardType, CardTemplateFormState;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FlashcardEditorController {
  const FlashcardEditorController({
    required this.formState,
    required this.cardType,
  });

  final CardTemplateFormState formState;
  final CardType cardType;

  TextEditingController get frontController => formState.frontController;
  TextEditingController get backController => formState.backController;

  String get directionHint {
    return switch (cardType) {
      CardType.both => 'Generates 2 Notes: Front to Back and Back to Front.',
      CardType.reversed => 'Generates 1 Note: Back to Front.',
      CardType.normal => 'Generates 1 Note: Front to Back.',
    };
  }

  void setCardType(CardType value) {
    formState.cardType.value = value;
  }
}

FlashcardEditorController useFlashcardEditor(CardTemplateFormState formState) {
  final cardType = useValueListenable(formState.cardType);

  return FlashcardEditorController(formState: formState, cardType: cardType);
}
