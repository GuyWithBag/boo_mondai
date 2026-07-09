import 'package:boo_mondai/lib.barrel.dart' show Controller;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'
    show useEffect, useListenable, useMemoized;

ToolBarController useToolBarController() {
  final controller = useMemoized(() => ToolBarController());
  useListenable(controller);
  useEffect(() => controller.dispose, [controller]);

  return controller;
}

class ToolBarController extends Controller {
  TextEditingController? _activeTextController;
  bool _activeTextAllowsAttachments = false;

  TextEditingController? get activeTextController => _activeTextController;
  bool get hasActiveTextController => _activeTextController != null;
  bool get activeTextAllowsAttachments =>
      hasActiveTextController && _activeTextAllowsAttachments;

  void setActiveTextController(
    TextEditingController controller, {
    bool allowAttachments = false,
  }) {
    if (_activeTextController == controller &&
        _activeTextAllowsAttachments == allowAttachments) {
      return;
    }
    _activeTextController = controller;
    _activeTextAllowsAttachments = allowAttachments;
    notifyListeners();
  }

  void clearActiveTextController(TextEditingController controller) {
    if (_activeTextController != controller) return;

    _activeTextController = null;
    _activeTextAllowsAttachments = false;
    notifyListeners();
  }

  void insertMarkdown(String markdown) {
    _replaceSelection(markdown);
  }

  void toggleBold() => wrapSelection('**', '**', placeholder: 'bold text');

  void toggleItalic() => wrapSelection('_', '_', placeholder: 'italic text');

  void toggleStrikethrough() =>
      wrapSelection('~~', '~~', placeholder: 'strikethrough text');

  void toggleInlineCode() => wrapSelection('`', '`', placeholder: 'code');

  void insertLink() => wrapSelection('[', '](https://)', placeholder: 'link');

  void insertImage() =>
      wrapSelection('![', '](https://)', placeholder: 'image alt');

  void insertCodeBlock() {
    _replaceSelection('```\n${_selectedTextOr('code')}\n```');
  }

  void insertHeading(int level) {
    final normalizedLevel = level.clamp(1, 6);
    _prefixSelectedLines('${'#' * normalizedLevel} ', placeholder: 'Heading');
  }

  void insertBlockQuote() {
    _prefixSelectedWholeLines('> ', placeholder: 'Quote');
  }

  void insertUnorderedList() {
    _prefixSelectedLines('- ', placeholder: 'List item');
  }

  void insertOrderedList() {
    final selected = _selectedText;
    if (selected == null || selected.isEmpty) {
      _replaceSelection('1. List item');
      return;
    }

    final lines = selected.split('\n');
    final replacement = [
      for (var index = 0; index < lines.length; index++)
        '${index + 1}. ${lines[index]}',
    ].join('\n');
    _replaceSelection(replacement);
  }

  void insertTaskList() {
    _prefixSelectedLines('- [ ] ', placeholder: 'Task');
  }

  void insertHorizontalRule() {
    _replaceSelection('\n---\n');
  }

  void insertTable() {
    _replaceSelection(
      '| Header | Header |\n'
      '| --- | --- |\n'
      '| Cell | Cell |',
    );
  }

  void applyCamelCase() {
    _transformSelectedText(_toCamelCase);
  }

  void applyPascalCase() {
    _transformSelectedText(_toPascalCase);
  }

  void applySnakeCase() {
    _transformSelectedText(_toSnakeCase);
  }

  void applyKebabCase() {
    _transformSelectedText(_toKebabCase);
  }

  void applyTitleCase() {
    _transformSelectedText(_toTitleCase);
  }

  void toggleUpperLowerCase() {
    _transformSelectedText((text) {
      return text == text.toUpperCase()
          ? text.toLowerCase()
          : text.toUpperCase();
    });
  }

  void indentSelectedLines() {
    _transformSelectedWholeLines((line) => '  $line');
  }

  void unindentSelectedLines() {
    _transformSelectedWholeLines((line) {
      if (line.startsWith('  ')) return line.substring(2);
      if (line.startsWith('\t')) return line.substring(1);
      if (line.startsWith(' ')) return line.substring(1);
      return line;
    });
  }

  void wrapSelection(
    String prefix,
    String suffix, {
    required String placeholder,
  }) {
    final selectedText = _selectedText;
    final content = selectedText == null || selectedText.isEmpty
        ? placeholder
        : selectedText;

    _replaceSelection('$prefix$content$suffix');
  }

  void _prefixSelectedLines(String prefix, {required String placeholder}) {
    final selected = _selectedText;
    if (selected == null || selected.isEmpty) {
      _replaceSelection('$prefix$placeholder');
      return;
    }

    _replaceSelection(
      selected.split('\n').map((line) => '$prefix$line').join('\n'),
    );
  }

  void _prefixSelectedWholeLines(String prefix, {required String placeholder}) {
    _transformSelectedWholeLineRange(
      placeholder: '$prefix$placeholder',
      transform: (affectedText) {
        if (affectedText.isEmpty) return '$prefix$placeholder';
        return affectedText
            .split('\n')
            .map((line) => '$prefix$line')
            .join('\n');
      },
    );
  }

  void _transformSelectedWholeLines(String Function(String line) transform) {
    _transformSelectedWholeLineRange(
      placeholder: '',
      transform: (affectedText) =>
          affectedText.split('\n').map(transform).join('\n'),
    );
  }

  void _transformSelectedWholeLineRange({
    required String placeholder,
    required String Function(String affectedText) transform,
  }) {
    final controller = _activeTextController;
    if (controller == null) return;

    final text = controller.text;
    final selection = controller.selection;
    final start = selection.isValid ? selection.start : text.length;
    final end = selection.isValid ? selection.end : text.length;
    final normalizedStart = start.clamp(0, text.length);
    final normalizedEnd = end.clamp(normalizedStart, text.length);

    if (text.isEmpty) {
      _replaceSelection(placeholder);
      return;
    }

    final lineStart = text.lastIndexOf('\n', normalizedStart - 1) + 1;
    final selectedEndsAtLineBreak =
        normalizedEnd > normalizedStart && text[normalizedEnd - 1] == '\n';
    final lineEndAnchor = selectedEndsAtLineBreak
        ? normalizedEnd - 1
        : normalizedEnd;
    final nextLineBreak = text.indexOf('\n', lineEndAnchor);
    final lineEnd = nextLineBreak == -1 ? text.length : nextLineBreak;
    final affectedText = text.substring(lineStart, lineEnd);
    final replacement = transform(affectedText);

    final updatedText = text.replaceRange(lineStart, lineEnd, replacement);
    final offset = lineStart + replacement.length;

    controller.value = controller.value.copyWith(
      text: updatedText,
      selection: TextSelection.collapsed(offset: offset),
      composing: TextRange.empty,
    );
  }

  void _transformSelectedText(String Function(String text) transform) {
    final controller = _activeTextController;
    if (controller == null) return;

    final text = controller.text;
    final selection = controller.selection;
    final range = _selectedOrCurrentWordRange(text, selection);
    if (range == null) return;

    final selectedText = text.substring(range.start, range.end);
    if (selectedText.isEmpty) return;

    final replacement = transform(selectedText);
    final updatedText = text.replaceRange(range.start, range.end, replacement);
    final selectionEnd = range.start + replacement.length;

    controller.value = controller.value.copyWith(
      text: updatedText,
      selection: TextSelection(
        baseOffset: range.start,
        extentOffset: selectionEnd,
      ),
      composing: TextRange.empty,
    );
  }

  ({int start, int end})? _selectedOrCurrentWordRange(
    String text,
    TextSelection selection,
  ) {
    if (text.isEmpty) return null;

    final start = selection.isValid ? selection.start : text.length;
    final end = selection.isValid ? selection.end : text.length;
    final normalizedStart = start.clamp(0, text.length);
    final normalizedEnd = end.clamp(normalizedStart, text.length);

    if (normalizedStart != normalizedEnd) {
      return (start: normalizedStart, end: normalizedEnd);
    }

    var wordStart = normalizedStart;
    while (wordStart > 0 && _isWordCharacter(text.codeUnitAt(wordStart - 1))) {
      wordStart--;
    }

    var wordEnd = normalizedStart;
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

  List<String> _caseWords(String text) {
    final separated = text
        .replaceAllMapped(
          RegExp(r'([a-z0-9])([A-Z])'),
          (match) => '${match[1]} ${match[2]}',
        )
        .replaceAllMapped(
          RegExp(r'([A-Z]+)([A-Z][a-z])'),
          (match) => '${match[1]} ${match[2]}',
        )
        .replaceAll(RegExp(r'[^A-Za-z0-9]+'), ' ');

    return separated
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map((word) => word.toLowerCase())
        .toList();
  }

  String _toCamelCase(String text) {
    final words = _caseWords(text);
    if (words.isEmpty) return text;
    return [
      words.first,
      for (final word in words.skip(1)) _capitalize(word),
    ].join();
  }

  String _toPascalCase(String text) {
    final words = _caseWords(text);
    if (words.isEmpty) return text;
    return words.map(_capitalize).join();
  }

  String _toSnakeCase(String text) {
    final words = _caseWords(text);
    if (words.isEmpty) return text;
    return words.join('_');
  }

  String _toKebabCase(String text) {
    final words = _caseWords(text);
    if (words.isEmpty) return text;
    return words.join('-');
  }

  String _toTitleCase(String text) {
    final words = _caseWords(text);
    if (words.isEmpty) return text;
    return words.map(_capitalize).join(' ');
  }

  String _capitalize(String word) {
    if (word.isEmpty) return word;
    return '${word[0].toUpperCase()}${word.substring(1)}';
  }

  String _selectedTextOr(String fallback) {
    final selected = _selectedText;
    return selected == null || selected.isEmpty ? fallback : selected;
  }

  String? get _selectedText {
    final controller = _activeTextController;
    if (controller == null) return null;

    final text = controller.text;
    final selection = controller.selection;
    final start = selection.isValid ? selection.start : text.length;
    final end = selection.isValid ? selection.end : text.length;
    final normalizedStart = start.clamp(0, text.length);
    final normalizedEnd = end.clamp(normalizedStart, text.length);
    return text.substring(normalizedStart, normalizedEnd);
  }

  void _replaceSelection(String markdown) {
    final controller = _activeTextController;
    if (controller == null) return;

    final text = controller.text;
    final selection = controller.selection;
    final start = selection.isValid ? selection.start : text.length;
    final end = selection.isValid ? selection.end : text.length;
    final normalizedStart = start.clamp(0, text.length);
    final normalizedEnd = end.clamp(normalizedStart, text.length);
    final updatedText = text.replaceRange(
      normalizedStart,
      normalizedEnd,
      markdown,
    );
    final offset = normalizedStart + markdown.length;

    controller.value = controller.value.copyWith(
      text: updatedText,
      selection: TextSelection.collapsed(offset: offset),
      composing: TextRange.empty,
    );
  }
}
