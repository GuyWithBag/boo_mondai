import 'package:boo_mondai/lib.barrel.dart'
    show CardTemplateDirection, FlashcardTemplate, CardTemplateEditorController;
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class FlashcardEditorController
    extends CardTemplateEditorController<FlashcardTemplate> {
  FlashcardEditorController({required super.editDeckController}) {
    frontController.text = template.frontText;
    backController.text = template.backText;
  }

  final frontController = TextEditingController();
  final backController = TextEditingController();

  late final direction = computed(() => template.direction);

  late final directionHint = computed(() {
    return switch (template.direction) {
      CardTemplateDirection.both =>
        'Generates 2 Notes: Front to Back and Back to Front.',
      CardTemplateDirection.reversed => 'Generates 1 Note: Back to Front.',
      CardTemplateDirection.normal => 'Generates 1 Note: Front to Back.',
    };
  });

  void updateFront(String value) {
    template = template.copyWith(frontText: value);
  }

  void updateBack(String value) {
    template = template.copyWith(backText: value);
  }

  void updateCardType(CardTemplateDirection value) {
    template = template.copyWith(direction: value);
  }

  @override
  void dispose() {
    frontController.dispose();
    backController.dispose();
    directionHint.dispose();
    direction.dispose();
    super.dispose();
  }
}
