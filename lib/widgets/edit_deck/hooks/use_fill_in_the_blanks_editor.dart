import 'package:boo_mondai/models/models.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FillInTheBlanksEditorState {
  const FillInTheBlanksEditorState({
    required this.sentence,
    required this.answers,
    required this.previewSentence,
    required this.canCreateBlank,
    required this.createBlankFromSelection,
    required this.removeBlankAt,
  });

  final String sentence;
  final List<String> answers;
  final String previewSentence;
  final bool canCreateBlank;
  final VoidCallback createBlankFromSelection;
  final ValueChanged<int> removeBlankAt;
}

FillInTheBlanksEditorState useFillInTheBlanksEditor({
  required TextEditingController sentenceController,
  required TextEditingController answersController,
}) {
  useListenable(sentenceController);
  useListenable(answersController);

  final sentence = sentenceController.text;
  final answers = splitFillInTheBlankAnswers(answersController.text);
  final selectedText = _selectedSentenceText(sentenceController);

  void writeAnswers(List<String> updatedAnswers) {
    answersController.text = updatedAnswers.join(', ');
    answersController.selection = TextSelection.collapsed(
      offset: answersController.text.length,
    );
  }

  void createBlankFromSelection() {
    final answer = _selectedSentenceText(sentenceController).trim();
    if (answer.isEmpty) return;

    writeAnswers([...answers, answer]);
  }

  void removeBlankAt(int index) {
    final updatedAnswers = [...answers]..removeAt(index);
    writeAnswers(updatedAnswers);
  }

  return FillInTheBlanksEditorState(
    sentence: sentence,
    answers: answers,
    previewSentence: _previewSentence(sentence, answers),
    canCreateBlank: selectedText.trim().isNotEmpty,
    createBlankFromSelection: createBlankFromSelection,
    removeBlankAt: removeBlankAt,
  );
}

String _selectedSentenceText(TextEditingController sentenceController) {
  final selection = sentenceController.selection;
  final sentence = sentenceController.text;
  if (!selection.isValid || selection.isCollapsed) return '';
  if (selection.start < 0 || selection.end > sentence.length) return '';
  return selection.textInside(sentence);
}

String _previewSentence(String sentence, List<String> answers) {
  var preview = sentence;
  for (final answer in answers) {
    if (answer.isEmpty) continue;
    preview = preview.replaceFirst(
      RegExp(RegExp.escape(answer), caseSensitive: false),
      '_' * answer.length,
    );
  }
  return preview;
}
