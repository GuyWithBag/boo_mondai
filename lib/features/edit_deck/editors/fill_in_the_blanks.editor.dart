import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        CardTemplateFormState,
        InlineSpanEntry,
        useFillInTheBlanksSpanController,
        surfaceStyle,
        SurfaceColor,
        textStyle,
        TextSize,
        TextWeight,
        TextColor,
        TextField,
        TextFieldSize,
        TextFieldFrame,
        TextFieldTone,
        Button,
        BlankChip;
import 'package:flutter/material.dart' hide TextField;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class FillInTheBlanksEditor extends HookWidget {
  const FillInTheBlanksEditor({required this.formState, super.key});

  final CardTemplateFormState formState;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    // Parse the initial blanks from the comma-separated answers controller.
    final blanks = useState<List<String>>(
      _parseBlanks(formState.fillInTheBlankAnswersController.text),
    );

    void writeBlanksToFormState(List<String> next) {
      blanks.value = next;
      // Serialize back to the existing comma-string controller so the rest
      // of the form state pipeline (save, validation) stays unchanged.
      final serialized = next.join(', ');
      if (formState.fillInTheBlankAnswersController.text != serialized) {
        formState.fillInTheBlankAnswersController.text = serialized;
      }
    }

    final spanController = useFillInTheBlanksSpanController(
      blanks: blanks.value,
      onBlanksChanged: writeBlanksToFormState,
    );

    // Inject the chip builder so visual style lives in the widget layer.
    spanController.chipBuilder = (context, index, entry) => BlankChip(
      entry: entry,
      onDelete: () {
        spanController.removeBlank(index);
        writeBlanksToFormState(spanController.blanks);
      },
    );

    // Listen to controller changes so canCreateBlank re-renders the button.
    useListenable(spanController);

    final resolvedTextStyle = textStyle.resolve(tokens, const [
      TextSize.label,
      TextWeight.body,
      TextColor.baseline,
    ]);

    return Surface(
      style: surfaceStyle.resolve(tokens, const [SurfaceColor.baseline]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sentence Builder'.toUpperCase(),
            style: textStyle.resolve(tokens, [
              TextSize.labelSmall,
              TextWeight.heavy,
              TextColor.muted,
            ]),
          ),
          const SizedBox(height: 14),
          Text(
            'Type your full sentence. Highlight the words you want the '
            'user to guess, then tap "Create Blank".',
            style: textStyle
                .resolve(tokens, [
                  TextSize.label,
                  TextWeight.body,
                  TextColor.muted,
                ])
                .copyWith(fontSize: 17),
          ),
          const SizedBox(height: 28),

          // ── Sentence field ────────────────────────────────────────────────
          // Uses the span controller directly — chips appear inline where
          // the selection was made.
          TextField(
            variants: const [
              TextFieldSize.normal,
              TextFieldFrame.outline,
              TextFieldTone.neutral,
            ],
            controller: spanController,
            style: resolvedTextStyle,
            placeholder: 'Type the full sentence…',
            minLines: 6,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
          ),

          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: Button(
              leading: const Icon(Icons.add),
              onPressed: spanController.canCreateBlank
                  ? () {
                      final created = spanController.createBlankFromSelection();
                      if (created) {
                        writeBlanksToFormState(spanController.blanks);
                      }
                    }
                  : null,
              child: const Text('Create Blank'),
            ),
          ),

          // ── Preview ───────────────────────────────────────────────────────
          if (spanController.rawTextOnly.trim().isNotEmpty ||
              blanks.value.isNotEmpty) ...[
            const SizedBox(height: 18),
            Surface(
              style: surfaceStyle.resolve(tokens, const [SurfaceColor.muted]),
              child: Text(
                _buildPreviewSentence(
                  spanController.value.text,
                  spanController.entries,
                ),
                style: TextStyle(
                  color: tokens.colorTextBaseline,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Rebuilds a preview string where each blank is replaced with underscores.
  String _buildPreviewSentence(
    String rawWithReplacements,
    List<InlineSpanEntry> entries,
  ) {
    var result = rawWithReplacements;
    var entryIndex = 0;
    return result.replaceAllMapped(RegExp(String.fromCharCode(0xFFFE)), (
      match,
    ) {
      if (entryIndex >= entries.length) return '___';
      final word = entries[entryIndex++].text;
      return '_' * word.length;
    });
  }
}

// =============================================================================
// Helpers
// =============================================================================

/// Parses a comma-separated answers string (as stored in
/// [CardTemplateFormState.fillInTheBlankAnswersController]) into a list of
/// individual blank words.
List<String> _parseBlanks(String raw) {
  if (raw.trim().isEmpty) return [];
  return raw
      .split(',')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();
}
