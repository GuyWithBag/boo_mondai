import 'package:flutter/material.dart';

extension ToolBarTextEditingControllerExtension on TextEditingController {
  String get selectedText {
    final range = normalizedSelectionRange;
    return text.substring(range.start, range.end);
  }

  String selectedTextOr(String fallback) {
    final selected = selectedText;
    return selected.isEmpty ? fallback : selected;
  }

  ({int start, int end}) get normalizedSelectionRange {
    final start = selection.isValid ? selection.start : text.length;
    final end = selection.isValid ? selection.end : text.length;
    final normalizedStart = start.clamp(0, text.length);
    final normalizedEnd = end.clamp(normalizedStart, text.length);
    return (start: normalizedStart, end: normalizedEnd);
  }

  void replaceSelection(String replacement) {
    final range = normalizedSelectionRange;
    final updatedText = text.replaceRange(range.start, range.end, replacement);
    final offset = range.start + replacement.length;

    value = value.copyWith(
      text: updatedText,
      selection: TextSelection.collapsed(offset: offset),
      composing: TextRange.empty,
    );
  }

  void replaceSelectedWholeLines({
    required String fallback,
    required String Function(String affectedText) transform,
  }) {
    final currentValue = value;
    final text = currentValue.text;
    final range = normalizedSelectionRange;

    if (text.isEmpty) {
      replaceSelection(fallback);
      return;
    }

    final lineStart = text.lastIndexOf('\n', range.start - 1) + 1;
    final selectedEndsAtLineBreak =
        range.end > range.start && text[range.end - 1] == '\n';
    final lineEndAnchor = selectedEndsAtLineBreak ? range.end - 1 : range.end;
    final nextLineBreak = text.indexOf('\n', lineEndAnchor);
    final lineEnd = nextLineBreak == -1 ? text.length : nextLineBreak;
    final affectedText = text.substring(lineStart, lineEnd);
    final replacement = transform(affectedText);

    final updatedText = text.replaceRange(lineStart, lineEnd, replacement);
    final offset = lineStart + replacement.length;

    value = currentValue.copyWith(
      text: updatedText,
      selection: TextSelection.collapsed(offset: offset),
      composing: TextRange.empty,
    );
  }

  void transformSelectedTextOrCurrentWord(
    String Function(String text) transform,
  ) {
    final range = selectedOrCurrentWordRange;
    if (range == null) return;

    final selectedText = text.substring(range.start, range.end);
    if (selectedText.isEmpty) return;

    final replacement = transform(selectedText);
    final updatedText = text.replaceRange(range.start, range.end, replacement);
    final selectionEnd = range.start + replacement.length;

    value = value.copyWith(
      text: updatedText,
      selection: TextSelection(
        baseOffset: range.start,
        extentOffset: selectionEnd,
      ),
      composing: TextRange.empty,
    );
  }

  ({int start, int end})? get selectedOrCurrentWordRange {
    if (text.isEmpty) return null;

    final range = normalizedSelectionRange;
    if (range.start != range.end) return range;

    var wordStart = range.start;
    while (wordStart > 0 && _isWordCharacter(text.codeUnitAt(wordStart - 1))) {
      wordStart--;
    }

    var wordEnd = range.start;
    while (wordEnd < text.length &&
        _isWordCharacter(text.codeUnitAt(wordEnd))) {
      wordEnd++;
    }

    if (wordStart == wordEnd) return null;
    return (start: wordStart, end: wordEnd);
  }

  bool _isWordCharacter(int codeUnit) {
    return (codeUnit >= 48 && codeUnit <= 57) ||
        (codeUnit >= 65 && codeUnit <= 90) ||
        (codeUnit >= 97 && codeUnit <= 122) ||
        codeUnit == 45 ||
        codeUnit == 95;
  }
}
