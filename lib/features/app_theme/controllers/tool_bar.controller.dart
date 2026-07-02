import 'package:boo_mondai/lib.barrel.dart' show Controller;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'
    show useEffect, useListenable, useMemoized;

ToolBarController useToolBarController() {
  final controller = useMemoized(ToolBarController.new);
  useListenable(controller);
  useEffect(() => controller.dispose, [controller]);

  return controller;
}

class ToolBarController extends Controller {
  TextEditingController? _activeTextController;

  TextEditingController? get activeTextController => _activeTextController;
  bool get hasActiveTextController => _activeTextController != null;

  void setActiveTextController(TextEditingController controller) {
    if (_activeTextController == controller) return;
    _activeTextController = controller;
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
    _prefixSelectedLines('> ', placeholder: 'Quote');
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
