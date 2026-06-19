import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        ChipTone,
        ReplacementSpanController,
        InlineSpanEntry,
        chipStyle;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart' show ThemeVariantsContext;

// =============================================================================
// Hook
// =============================================================================

FillInTheBlanksSpanController useFillInTheBlanksSpanController({
  required List<String> blanks,
  required ValueChanged<List<String>> onBlanksChanged,
}) {
  final controller = useMemoized(
    () => FillInTheBlanksSpanController(blanks: blanks),
    [],
  );
  useEffect(() => controller.dispose, [controller]);

  // Keep caller's blanks list in sync if it changes externally.
  useEffect(() {
    controller.syncBlanks(blanks);
    return null;
  }, [blanks]);

  return controller;
}

// =============================================================================
// Controller
// =============================================================================

/// A [ReplacementSpanController] for the fill-in-the-blanks sentence field.
///
/// Each [InlineSpanEntry] is a word/phrase the user selected and "blanked out".
/// Blanks are positional — they live at the exact offset in the sentence where
/// the selection was made, not prepended to the front.
///
/// **Chip rendering** is injected via [chipBuilder] so the widget layer owns
/// visual style without coupling it to the controller.
class FillInTheBlanksSpanController
    extends ReplacementSpanController<InlineSpanEntry> {
  FillInTheBlanksSpanController({required List<String> blanks})
    : super(entries: [], text: '');

  /// Called by the widget layer to provide chip rendering.
  Widget Function(BuildContext context, int index, InlineSpanEntry entry)?
  chipBuilder;

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Words that have been blanked out, in document order.
  List<String> get blanks => entries.map((e) => e.text).toList();

  /// Try to create a blank from the current [TextSelection].
  /// Returns false if the selection is empty or collapsed.
  bool createBlankFromSelection() {
    final sel = selection;
    if (!sel.isValid || sel.isCollapsed) return false;

    final raw = value.text;
    final start = sel.start;
    final end = sel.end;

    // The selected range may contain replacement chars from existing blanks —
    // strip them to recover the visible word.
    final selectedRaw = raw.substring(start, end);
    final word = selectedRaw.replaceAll(String.fromCharCode(0xFFFE), '');
    if (word.trim().isEmpty) return false;

    // Splice a replacement char in place of the selected text.
    final before = raw.substring(0, start);
    final after = raw.substring(end);
    final next = before + String.fromCharCode(0xFFFE) + after;

    // Determine insertion index = number of replacement chars before [start].
    final insertionIndex = before.codeUnits.where((u) => u == 0xFFFE).length;

    // Insert the entry at the right position in the list.
    final newEntries = List<InlineSpanEntry>.of(entries)
      ..insert(insertionIndex, InlineSpanEntry(text: word.trim()));

    // Bypass setEntries since we're also replacing the text (not just
    // prepending or rebuilding from scratch).
    setEntries(
      newEntries,
      rawText: next.replaceAll(String.fromCharCode(0xFFFE), ''),
    );

    // Actually set the value with the spliced replacement char.
    value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: start + 1),
    );

    return true;
  }

  /// Remove the blank at [index], restoring its word to the sentence text.
  void removeBlank(int index) {
    if (index < 0 || index >= entries.length) return;
    final word = entries[index].text;
    final charIndex = charIndexOfNthReplacement(index);
    if (charIndex == -1) return;

    final t = value.text;
    // Replace the replacement char with the original word text.
    final next = t.substring(0, charIndex) + word + t.substring(charIndex + 1);

    final newEntries = List<InlineSpanEntry>.of(entries)..removeAt(index);
    // Directly update entries and value — don't use removeEntry since we're
    // inserting text (not just deleting a char).
    setEntries(
      newEntries,
      rawText: next.replaceAll(String.fromCharCode(0xFFFE), ''),
    );
    value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: charIndex + word.length),
    );
  }

  /// Sync from an external blanks list (e.g. if loaded from saved state).
  /// Preserves the current raw sentence text.
  void syncBlanks(List<String> blanks) {
    final current = entries.map((e) => e.text).toList();
    if (_listEquals(current, blanks)) return;
    // Rebuild entries preserving positions as best we can.
    final newEntries = blanks.asMap().entries.map((e) {
      return InlineSpanEntry(text: e.value);
    }).toList();
    setEntries(newEntries);
  }

  /// Whether there is a non-collapsed selection that can become a blank.
  bool get canCreateBlank {
    final sel = selection;
    return sel.isValid && !sel.isCollapsed;
  }

  // ---------------------------------------------------------------------------
  // Span rendering (delegates to injected chipBuilder)
  // ---------------------------------------------------------------------------

  @override
  Widget buildSpanWidget(
    BuildContext context,
    int index,
    InlineSpanEntry entry,
  ) {
    return chipBuilder?.call(context, index, entry) ??
        _DefaultBlankChip(entry: entry, onDelete: () => removeBlank(index));
  }

  // ---------------------------------------------------------------------------
  // Private
  // ---------------------------------------------------------------------------

  static bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

// =============================================================================
// Default chip widget (used when no chipBuilder is injected)
// =============================================================================

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
