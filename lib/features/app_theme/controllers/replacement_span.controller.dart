import 'package:flutter/material.dart'
    show
        BuildContext,
        PlaceholderAlignment,
        TextEditingController,
        TextEditingValue,
        TextSelection,
        TextSpan,
        TextStyle,
        Widget,
        WidgetSpan,
        InlineSpan;

// =============================================================================
// Shared primitive
// =============================================================================

/// Unicode private-use char used as a placeholder in the raw text string for
/// every inline widget span. One char = one span, positional.
const int kReplacementChar = 0xFFFE;
final String _kReplacementStr = String.fromCharCode(kReplacementChar);

/// A [TextEditingController] base that knows how to render a list of
/// [InlineSpanEntry] objects as inline widget spans inside the text field,
/// using a Unicode private-use replacement character to hold each span's
/// position in the raw string.
///
/// Subclasses own:
/// - their data model ([entries])
/// - the concrete [Widget] each entry renders as (via [buildSpanWidget])
/// - any public mutation API
///
/// This base class owns:
/// - keeping replacement chars in sync with [entries.length]
/// - [buildTextSpan] — interleaving span widgets with literal text runs
/// - helpers: [replacementCount], [rawTextOnly]
abstract class ReplacementSpanController<InlineSpanEntry>
    extends TextEditingController {
  ReplacementSpanController({
    required List<InlineSpanEntry> entries,
    String text = '',
  }) : _entries = List.of(entries),
       super(text: _kReplacementStr * entries.length + text);

  // ---------------------------------------------------------------------------
  // Internal state
  // ---------------------------------------------------------------------------

  List<InlineSpanEntry> _entries;

  /// The ordered list of span entries. Each entry corresponds to one
  /// replacement char in the raw [value.text].
  List<InlineSpanEntry> get entries => List.unmodifiable(_entries);

  // ---------------------------------------------------------------------------
  // Subclass contract
  // ---------------------------------------------------------------------------

  /// Build the widget shown inline for [entry] at [index].
  Widget buildSpanWidget(
    BuildContext context,
    int index,
    InlineSpanEntry entry,
  );

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  /// Number of replacement chars currently in [text] — should equal
  /// [_entries.length] after any mutation.
  int get replacementCount =>
      text.codeUnits.where((u) => u == kReplacementChar).length;

  /// The raw text with all replacement chars stripped — i.e. what the user
  /// actually typed, not counting span placeholders.
  String get rawTextOnly => text.replaceAll(_kReplacementStr, '');

  // ---------------------------------------------------------------------------
  // Protected mutation helpers
  // ---------------------------------------------------------------------------

  /// Replace the entire entry list and rebuild [value] to match, preserving
  /// the trailing user-typed text.
  void setEntries(List<InlineSpanEntry> nextEntries, {String? rawText}) {
    _entries = List.of(nextEntries);
    _rebuildValue(rawText: rawText ?? rawTextOnly);
  }

  /// Insert a new entry at [index] within [_entries] and splice a replacement
  /// char into the raw text at the corresponding position.
  void insertEntry(int index, InlineSpanEntry entry, {int? rawOffset}) {
    _entries.insert(index, entry);
    final current = value.text;
    // Find the character position in the raw string that corresponds to
    // inserting after the [index]-th replacement char.
    final insertAt = rawOffset ?? _charOffsetForEntryIndex(index);
    final next =
        current.substring(0, insertAt) +
        _kReplacementStr +
        current.substring(insertAt);
    value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: insertAt + 1),
    );
  }

  /// Remove entry at [index] and its corresponding replacement char.
  void removeEntry(int index) {
    if (index < 0 || index >= _entries.length) return;
    _entries.removeAt(index);
    final charIndex = charIndexOfNthReplacement(index);
    if (charIndex == -1) return;
    final t = value.text;
    final next = t.substring(0, charIndex) + t.substring(charIndex + 1);
    value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(
        offset: (value.selection.baseOffset - 1).clamp(0, next.length),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // buildTextSpan
  // ---------------------------------------------------------------------------

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final raw = value.text;
    final children = <InlineSpan>[];
    var entryIndex = 0;
    var textStart = 0;

    for (var i = 0; i < raw.length; i++) {
      if (raw.codeUnitAt(i) == kReplacementChar) {
        // Flush any literal text before this span.
        if (i > textStart) {
          children.add(TextSpan(text: raw.substring(textStart, i)));
        }
        // Add the widget span if we have a matching entry.
        if (entryIndex < _entries.length) {
          final entry = _entries[entryIndex];
          children.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: buildSpanWidget(context, entryIndex, entry),
            ),
          );
          entryIndex++;
        }
        textStart = i + 1;
      }
    }

    // Flush any trailing literal text.
    if (textStart < raw.length) {
      children.add(TextSpan(text: raw.substring(textStart)));
    }

    return TextSpan(style: style, children: children);
  }

  // ---------------------------------------------------------------------------
  // Private
  // ---------------------------------------------------------------------------

  void _rebuildValue({required String rawText}) {
    value = TextEditingValue(
      text: _kReplacementStr * _entries.length + rawText,
      selection: TextSelection.collapsed(
        offset: _entries.length + rawText.length,
      ),
    );
  }

  /// Returns the character index in [value.text] of the [n]-th replacement
  /// char (0-indexed), or -1 if not found.
  int charIndexOfNthReplacement(int n) {
    var count = 0;
    for (var i = 0; i < value.text.length; i++) {
      if (value.text.codeUnitAt(i) == kReplacementChar) {
        if (count == n) return i;
        count++;
      }
    }
    return -1;
  }

  /// Character offset at which to insert a replacement char for a new entry
  /// at [index] — i.e. just after the [index-1]-th existing replacement.
  int _charOffsetForEntryIndex(int index) {
    if (index == 0) return 0;
    return (charIndexOfNthReplacement(index - 1) + 1).clamp(
      0,
      value.text.length,
    );
  }
}
