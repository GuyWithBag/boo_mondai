import 'package:boo_mondai/lib.barrel.dart'
    show CardTemplateDirection, FlashcardTemplate;
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class FlashcardEditorController {
  FlashcardEditorController({required this.template, required this.onChanged}) {
    frontController.text = template.frontText;
    backController.text = template.backText;
    direction.value = template.direction;
    verticallyCentered.value = template.verticallyCentered;
  }

  final FlashcardTemplate template;
  final ValueChanged<FlashcardTemplate> onChanged;

  final frontController = TextEditingController();
  final backController = TextEditingController();
  final direction = signal(CardTemplateDirection.normal);
  final verticallyCentered = signal(true);

  late final directionHint = computed(() {
    return switch (direction.value) {
      CardTemplateDirection.both =>
        'Generates 2 Notes: Front to Back and Back to Front.',
      CardTemplateDirection.reversed => 'Generates 1 Note: Back to Front.',
      CardTemplateDirection.normal => 'Generates 1 Note: Front to Back.',
    };
  });

  void updateFront(String value) => emit(frontText: value);

  void updateBack(String value) => emit(backText: value);

  void updateCardType(CardTemplateDirection value) {
    direction.value = value;
    emit(direction: value);
  }

  void updateVerticallyCentered(bool value) {
    verticallyCentered.value = value;
    emit(verticallyCentered: value);
  }

  void emit({
    String? frontText,
    String? backText,
    CardTemplateDirection? direction,
    bool? verticallyCentered,
  }) {
    onChanged(
      FlashcardTemplate(
        id: template.id,
        deckId: template.deckId,
        sortOrder: template.sortOrder,
        createdAt: template.createdAt,
        updatedAt: DateTime.now(),
        deletedAt: template.deletedAt,
        purgeAfter: template.purgeAfter,
        sourceTemplateId: template.sourceTemplateId,
        tags: template.tags,
        verticallyCentered: verticallyCentered ?? this.verticallyCentered.value,
        frontText: frontText ?? frontController.text,
        backText: backText ?? backController.text,
        direction: direction ?? this.direction.value,
      ),
    );
  }

  void dispose() {
    frontController.dispose();
    backController.dispose();
    direction.dispose();
    verticallyCentered.dispose();
    directionHint.dispose();
  }
}
