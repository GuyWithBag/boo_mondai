import 'package:boo_mondai/lib.barrel.dart' show WordScrambleTemplate;
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class WordScrambleEditorController {
  WordScrambleEditorController({
    required this.template,
    required this.onChanged,
  }) {
    sentenceController.text = template.sentenceToScramble;
    verticallyCentered.value = template.verticallyCentered;
  }

  final WordScrambleTemplate template;
  final ValueChanged<WordScrambleTemplate> onChanged;

  final sentenceController = TextEditingController();
  final verticallyCentered = signal(true);

  void updateSentence(String value) => emit(sentenceToScramble: value);

  void updateVerticallyCentered(bool value) {
    verticallyCentered.value = value;
    emit(verticallyCentered: value);
  }

  void emit({String? sentenceToScramble, bool? verticallyCentered}) {
    onChanged(
      WordScrambleTemplate(
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
        sentenceToScramble: sentenceToScramble ?? sentenceController.text,
      ),
    );
  }

  void dispose() {
    sentenceController.dispose();
    verticallyCentered.dispose();
  }
}
