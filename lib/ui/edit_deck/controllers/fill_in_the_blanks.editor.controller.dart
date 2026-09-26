import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        ChipTone,
        FillInTheBlankSegment,
        FillInTheBlanksTemplate,
        ReplacementSpanController,
        InlineSpanEntry,
        chipStyle,
        uuid;
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:theme_variants/theme_variants.dart' show ThemeVariantsContext;

class FillInTheBlanksEditorController {
  FillInTheBlanksEditorController({
    required this.template,
    required this.onChanged,
  }) {
    verticallyCentered.value = template.verticallyCentered;
    final sorted = template.segments.toList()
      ..sort((a, b) => a.blankStart.compareTo(b.blankStart));
    spanController = FillInTheBlanksSpanController(
      text: sorted.firstOrNull?.fullText ?? '',
      blanks: [for (final segment in sorted) segment.correctAnswer],
    );
  }

  final FillInTheBlanksTemplate template;
  final ValueChanged<FillInTheBlanksTemplate> onChanged;

  final verticallyCentered = signal(true);
  late final FillInTheBlanksSpanController spanController;

  void updateVerticallyCentered(bool value) {
    verticallyCentered.value = value;
    emit(verticallyCentered: value);
  }

  void emit({bool? verticallyCentered}) {
    onChanged(
      FillInTheBlanksTemplate(
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
        segments: buildSegments(),
      ),
    );
  }

  List<FillInTheBlankSegment> buildSegments() {
    final sentence = spanController.rawTextOnly.trim();
    final blanks = spanController.blanks
        .map((blank) => blank.trim())
        .where((blank) => blank.isNotEmpty)
        .toList();
    if (sentence.isEmpty || blanks.isEmpty) return [];

    final lowerSentence = sentence.toLowerCase();
    var searchStart = 0;
    final segments = <FillInTheBlankSegment>[];

    for (final blank in blanks) {
      final lowerBlank = blank.toLowerCase();
      var blankStart = lowerSentence.indexOf(lowerBlank, searchStart);
      if (blankStart == -1) {
        blankStart = lowerSentence.indexOf(lowerBlank);
      }
      if (blankStart == -1) continue;

      final blankEnd = blankStart + blank.length;
      searchStart = blankEnd;
      segments.add(
        FillInTheBlankSegment(
          id: uuid.v7(),
          cardId: template.id,
          fullText: sentence,
          blankStart: blankStart,
          blankEnd: blankEnd,
          correctAnswer: blank,
        ),
      );
    }

    return segments;
  }

  void dispose() {
    verticallyCentered.dispose();
    spanController.dispose();
  }
}

/// A [ReplacementSpanController] for the fill-in-the-blanks sentence field.
///
/// Each [InlineSpanEntry] is a word/phrase the user selected and "blanked out".
/// Blanks are positional; they live at the exact offset in the sentence where
/// the selection was made, not prepended to the front.
class FillInTheBlanksSpanController
    extends ReplacementSpanController<InlineSpanEntry> {
  FillInTheBlanksSpanController({
    required super.text,
    required List<String> blanks,
  }) : super(
         entries: [for (final blank in blanks) InlineSpanEntry(text: blank)],
       );

  Widget Function(BuildContext context, int index, InlineSpanEntry entry)?
  chipBuilder;

  List<String> get blanks => entries.map((e) => e.text).toList();

  bool createBlankFromSelection() {
    final sel = selection;
    if (!sel.isValid || sel.isCollapsed) return false;

    final raw = value.text;
    final start = sel.start;
    final end = sel.end;

    final selectedRaw = raw.substring(start, end);
    final word = selectedRaw.replaceAll(String.fromCharCode(0xFFFE), '');
    if (word.trim().isEmpty) return false;

    final before = raw.substring(0, start);
    final after = raw.substring(end);
    final next = before + String.fromCharCode(0xFFFE) + after;
    final insertionIndex = before.codeUnits.where((u) => u == 0xFFFE).length;

    final newEntries = List<InlineSpanEntry>.of(entries)
      ..insert(insertionIndex, InlineSpanEntry(text: word.trim()));

    setEntries(
      newEntries,
      rawText: next.replaceAll(String.fromCharCode(0xFFFE), ''),
    );

    value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: start + 1),
    );

    return true;
  }

  void removeBlank(int index) {
    if (index < 0 || index >= entries.length) return;
    final word = entries[index].text;
    final charIndex = charIndexOfNthReplacement(index);
    if (charIndex == -1) return;

    final t = value.text;
    final next = t.substring(0, charIndex) + word + t.substring(charIndex + 1);

    final newEntries = List<InlineSpanEntry>.of(entries)..removeAt(index);
    setEntries(
      newEntries,
      rawText: next.replaceAll(String.fromCharCode(0xFFFE), ''),
    );
    value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: charIndex + word.length),
    );
  }

  void syncBlanks(List<String> blanks) {
    final current = entries.map((e) => e.text).toList();
    if (_listEquals(current, blanks)) return;
    final newEntries = blanks.asMap().entries.map((e) {
      return InlineSpanEntry(text: e.value);
    }).toList();
    setEntries(newEntries);
  }

  bool get canCreateBlank {
    final sel = selection;
    return sel.isValid && !sel.isCollapsed;
  }

  @override
  Widget buildSpanWidget(
    BuildContext context,
    int index,
    InlineSpanEntry entry,
  ) {
    return chipBuilder?.call(context, index, entry) ??
        _DefaultBlankChip(entry: entry, onDelete: () => removeBlank(index));
  }

  static bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

class _DefaultBlankChip extends StatelessWidget {
  const _DefaultBlankChip({required this.entry, required this.onDelete});

  final InlineSpanEntry entry;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final theme = chipStyle.resolve(tokens, [ChipTone.ghost]);
    return ChipTheme(
      data: theme,
      child: InputChip(label: Text(entry.text), onDeleted: onDelete),
    );
  }
}
