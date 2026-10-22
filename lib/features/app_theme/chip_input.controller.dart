import 'package:boo_mondai/lib.barrel.dart'
    show ReplacementSpanController, InlineSpanEntry;
import 'package:flutter/material.dart'
    show
        BuildContext,
        Widget,
        TextEditingController,
        TextEditingValue,
        TextSelection;
import 'package:flutter_hooks/flutter_hooks.dart' show useMemoized, useEffect;

ChipInputEditingController useChipInputController({
  required List<String> values,
  required Widget Function(BuildContext context, String value) chipBuilder,
  TextEditingController? externalController,
}) {
  final controller = useMemoized(
    () => ChipInputEditingController(
      values: values,
      chipBuilder: chipBuilder,
      text: externalController?.text ?? '',
    ),
    [externalController],
  );
  useEffect(() => controller.dispose, [controller]);
  return controller;
}

// =============================================================================
// Controller
// =============================================================================

/// A [ReplacementSpanController] that renders each [InlineSpanEntry] as an inline
/// chip widget, prepended before any user-typed text.
///
/// All chips live at the front of the raw string (indices 0..n-1), followed
/// by the user's trailing text. This matches the previous implementation
/// exactly so [ChipInput] needs no changes.
class ChipInputEditingController
    extends ReplacementSpanController<InlineSpanEntry> {
  ChipInputEditingController({
    required List<String> values,
    required this.chipBuilder,
    super.text,
  }) : super(
         entries: values.map((value) => InlineSpanEntry(text: value)).toList(),
       );

  Widget Function(BuildContext context, String value) chipBuilder;

  // ---------------------------------------------------------------------------
  // Compat API (unchanged surface from old controller)
  // ---------------------------------------------------------------------------

  /// Chip values in order.
  List<String> get values => entries.map((e) => e.text).toList();

  /// Number of replacement chars — always equals [values.length].
  // replacementCount inherited.

  /// Text the user typed, without replacement chars.
  String get textWithoutReplacements => rawTextOnly;

  void setChipBuilder(
    Widget Function(BuildContext context, String value) newBuilder,
  ) {
    chipBuilder = newBuilder;
  }

  /// Sync the values list, preserving the current trailing text.
  void updateValues(List<String> nextValues) {
    if (_chipListEquals(values, nextValues)) return;
    setEntries(
      nextValues.map((value) => InlineSpanEntry(text: value)).toList(),
    );
  }

  /// Replace the trailing user text without touching chips.
  void setTextWithoutReplacements(String inputText) {
    value = TextEditingValue(
      text: String.fromCharCode(0xFFFE) * entries.length + inputText,
      selection: TextSelection.collapsed(
        offset: entries.length + inputText.length,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Span rendering
  // ---------------------------------------------------------------------------

  @override
  Widget buildSpanWidget(
    BuildContext context,
    int index,
    InlineSpanEntry entry,
  ) {
    return chipBuilder(context, entry.text);
  }

  // ---------------------------------------------------------------------------
  // Private
  // ---------------------------------------------------------------------------

  static bool _chipListEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
