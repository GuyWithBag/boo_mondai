import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        AnswerKeyTile,
        Button,
        CardVerticalAlignmentControl,
        ChipTone,
        EditDeckController,
        EditDeckFormValidator,
        FillInTheBlanksEditorController,
        FormField,
        SectionEyebrow,
        SurfaceColor,
        TextColor,
        TextFieldCard,
        TextSize,
        TextWeight,
        chipStyle,
        surfaceStyle,
        textStyle,
        SurfaceShape;
import 'package:flutter/material.dart' hide FormField, TextField;
import 'package:flutter_hooks/flutter_hooks.dart'
    show useEffect, useListenable, useMemoized;
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class FillInTheBlanksEditor extends SignalHookWidget {
  const FillInTheBlanksEditor({required this.editDeckController, super.key});

  final EditDeckController editDeckController;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final editor = useMemoized(
      () => FillInTheBlanksEditorController(
        editDeckController: editDeckController,
      ),
      [editDeckController.selectedTemplateKey.value],
    );
    useEffect(() => editor.dispose, [editor]);
    useListenable(editor.promptController);
    final answerKeys = editor.answerKeys.value;
    final segments = editor.segments.value;

    return Column(
      spacing: tokens.spaceLayoutGapMd,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FormField<String>(
          value: editor.promptController.text,
          validator: EditDeckFormValidator.prompt,
          builder: (_, field) => TextFieldCard(
            title: 'Prompt',
            placeholder: 'Type the full sentence...',
            controller: editor.promptController,
            minHeight: 220,
            onChanged: (value) {
              field.didChange(value);
              editor.updatePrompt(value);
            },
          ),
        ),
        FormField<List<String>>(
          value: editor.buildKeys().map((key) => key.value).toList(),
          validator: EditDeckFormValidator.fillInTheBlankAnswers,
          builder: (_, _) => Surface(
            style: surfaceStyle
                .resolve(tokens, const [SurfaceShape.roundedSm])
                .copyWith(
                  padding: EdgeInsets.symmetric(
                    vertical: tokens.spaceLayoutPaddingLg,
                    horizontal: tokens.spaceLayoutPaddingSm,
                  ),
                ),
            child: Column(
              spacing: tokens.spaceLayoutGapMd,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SectionEyebrow('Answer Keys'),
                    Text(
                      'Matched in prompt',
                      style: textStyle.resolve(tokens, const [
                        TextSize.labelSmall,
                        TextWeight.heavy,
                        TextColor.muted,
                      ]),
                    ),
                  ],
                ),
                Column(
                  spacing: tokens.spaceLayoutGapMd,
                  children: [
                    for (final entry in answerKeys.asMap().entries)
                      AnswerKeyTile(
                        index: entry.key,
                        value: entry.value.value,
                        casingType: entry.value.casingType,
                        canMoveUp: entry.key > 0,
                        canMoveDown: entry.key < answerKeys.length - 1,
                        canRemove: true,
                        onCasingTypeChanged: (value) =>
                            editor.updateAnswerKeyCasingType(entry.key, value),
                        onMoveUp: () => editor.moveAnswerKeyUp(entry.key),
                        onMoveDown: () => editor.moveAnswerKeyDown(entry.key),
                        onRemove: () => editor.removeAnswerKey(entry.key),
                        valueChild: Align(
                          alignment: Alignment.centerLeft,
                          child: _BlankChip(
                            value: entry.value.value,
                            onDeleted: () => editor.removeAnswerKey(entry.key),
                          ),
                        ),
                      ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Button(
                    leading: const Icon(Icons.add),
                    onPressed: editor.canCreateBlank
                        ? editor.createBlankFromSelection
                        : null,
                    child: const Text('Create Blank'),
                  ),
                ),
                if (editor.promptText.value.trim().isNotEmpty) ...[
                  Surface(
                    style: surfaceStyle.resolve(tokens, const [
                      SurfaceColor.muted,
                    ]),
                    child: Wrap(
                      spacing: tokens.spaceLayoutGapSm,
                      runSpacing: tokens.spaceLayoutGapSm,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        for (final segment in segments)
                          if (segment.key == null)
                            Text(
                              segment.text ?? '',
                              style: TextStyle(
                                color: tokens.colorTextBaseline,
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                height: 1.5,
                              ),
                            )
                          else
                            _BlankChip(
                              value: segment.key!.value,
                              onDeleted: null,
                            ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        CardVerticalAlignmentControl(
          value: editor.template.verticallyCentered,
          onChanged: editor.onVerticalAlignmentControlChanged,
        ),
      ],
    );
  }
}

class _BlankChip extends StatelessWidget {
  const _BlankChip({required this.value, required this.onDeleted});

  final String value;
  final VoidCallback? onDeleted;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    return ChipTheme(
      data: chipStyle.resolve(tokens, [ChipTone.ghost]),
      child: InputChip(label: Text(value), onDeleted: onDeleted),
    );
  }
}
