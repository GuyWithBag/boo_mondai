import 'package:boo_mondai/lib.barrel.dart'
    show WordScrambleTemplate, CardTemplateEditorController;
import 'package:flutter/material.dart';

class WordScrambleEditorController
    extends CardTemplateEditorController<WordScrambleTemplate> {
  WordScrambleEditorController({required super.editDeckController}) {
    sentenceController.text = template.sentenceToScramble;
  }

  final sentenceController = TextEditingController();

  void updateSentence(String value) {
    template = template.copyWith(sentenceToScramble: value);
  }

  @override
  void dispose() {
    sentenceController.dispose();
    super.dispose();
  }
}
