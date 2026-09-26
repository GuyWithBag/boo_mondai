import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        BlankChip,
        Button,
        CardVerticalAlignmentControl,
        EditDeckFormValidator,
        FillInTheBlanksEditorController,
        FillInTheBlanksTemplate,
        FormField,
        InlineSpanEntry,
        SurfaceColor,
        TextColor,
        TextField,
        TextFieldFrame,
        TextFieldSize,
        TextSize,
        TextWeight,
        surfaceStyle,
        textStyle;
import 'package:flutter/material.dart' hide FormField, TextField;
import 'package:flutter_hooks/flutter_hooks.dart'
    show useEffect, useListenable, useMemoized;
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class FillInTheBlanksEditor extends SignalHookWidget {
  const FillInTheBlanksEditor({
    required this.template,
    required this.onChanged,
    super.key,
  });

  final FillInTheBlanksTemplate template;
  final ValueChanged<FillInTheBlanksTemplate> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final editor = useMemoized(
      () => FillInTheBlanksEditorController(
        template: template,
        onChanged: onChanged,
      ),
      [template.id],
    );
    useEffect(() => editor.dispose, [editor]);
    final spanController = editor.spanController;

    spanController.chipBuilder = (context, index, entry) => BlankChip(
      entry: entry,
      onDelete: () {
        spanController.removeBlank(index);
        editor.emit();
      },
    );

    useListenable(spanController);

    final resolvedTextStyle = textStyle.resolve(tokens, const [
      TextSize.label,
      TextWeight.body,
      TextColor.baseline,
    ]);

    return Column(
      spacing: tokens.spaceLayoutGapMd,
      children: [
        CardVerticalAlignmentControl(
          value: editor.verticallyCentered,
          onChanged: editor.updateVerticallyCentered,
        ),
        FormField<List<String>>(
          value: spanController.blanks,
          validator: EditDeckFormValidator.fillInTheBlankAnswers,
          builder: (_, _) => Surface(
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
                TextField(
                  variants: const [
                    TextFieldSize.normal,
                    TextFieldFrame.outline,
                  ],
                  controller: spanController,
                  style: resolvedTextStyle,
                  placeholder: 'Type the full sentence…',
                  minLines: 6,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  onChanged: (_) => editor.emit(),
                ),
                const SizedBox(height: 14),
                Align(
                  alignment: Alignment.centerRight,
                  child: Button(
                    leading: const Icon(Icons.add),
                    onPressed: spanController.canCreateBlank
                        ? () {
                            final created = spanController
                                .createBlankFromSelection();
                            if (created) editor.emit();
                          }
                        : null,
                    child: const Text('Create Blank'),
                  ),
                ),
                if (spanController.rawTextOnly.trim().isNotEmpty ||
                    spanController.blanks.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Surface(
                    style: surfaceStyle.resolve(tokens, const [
                      SurfaceColor.muted,
                    ]),
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
          ),
        ),
      ],
    );
  }

  String _buildPreviewSentence(
    String rawWithReplacements,
    List<InlineSpanEntry> entries,
  ) {
    var entryIndex = 0;
    return rawWithReplacements.replaceAllMapped(
      RegExp(String.fromCharCode(0xFFFE)),
      (_) {
        if (entryIndex >= entries.length) return '___';
        final word = entries[entryIndex++].text;
        return '_' * word.length;
      },
    );
  }
}
