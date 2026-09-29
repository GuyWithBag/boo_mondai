import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        CardVerticalAlignmentControl,
        CasingType,
        ChipTone,
        EditDeckController,
        EditDeckFormValidator,
        FillInTheBlankAnswerKey,
        FillInTheBlanksEditorController,
        FormField,
        SectionEyebrow,
        SegmentOption,
        SegmentedControl,
        SurfaceBorder,
        SurfaceColor,
        SurfacePadding,
        SurfaceShadow,
        TextColor,
        TextFieldCard,
        TextSize,
        TextWeight,
        chipStyle,
        surfaceStyle,
        textStyle;
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
        CardVerticalAlignmentControl(
          value: editor.template.verticallyCentered,
          onChanged: editor.onVerticalAlignmentControlChanged,
        ),
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
            style: surfaceStyle.resolve(tokens, const [SurfaceColor.baseline]),
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
                      _FillInTheBlankAnswerKeyRow(
                        index: entry.key,
                        value: entry.value,
                        canMoveUp: entry.key > 0,
                        canMoveDown: entry.key < answerKeys.length - 1,
                        canRemove: true,
                        onCasingTypeChanged: (value) =>
                            editor.updateAnswerKeyCasingType(entry.key, value),
                        onMoveUp: () => editor.moveAnswerKeyUp(entry.key),
                        onMoveDown: () => editor.moveAnswerKeyDown(entry.key),
                        onRemove: () => editor.removeAnswerKey(entry.key),
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
      ],
    );
  }
}

class _FillInTheBlankAnswerKeyRow extends StatelessWidget {
  const _FillInTheBlankAnswerKeyRow({
    required this.index,
    required this.value,
    required this.canMoveUp,
    required this.canMoveDown,
    required this.canRemove,
    required this.onCasingTypeChanged,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onRemove,
  });

  final int index;
  final FillInTheBlankAnswerKey value;
  final bool canMoveUp;
  final bool canMoveDown;
  final bool canRemove;
  final ValueChanged<CasingType> onCasingTypeChanged;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Surface(
      style: surfaceStyle
          .resolve(tokens, const [
            SurfaceColor.muted,
            SurfaceBorder.baseline,
            SurfacePadding.sm,
            SurfaceShadow.none,
          ])
          .copyWith(padding: EdgeInsets.all(tokens.spaceLayoutGapSm)),
      child: Column(
        spacing: tokens.spaceLayoutGapSm,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            spacing: tokens.spaceLayoutGapSm,
            children: [
              Text(
                '${index + 1}.',
                style: textStyle.resolve(tokens, const [
                  TextSize.label,
                  TextWeight.heavy,
                  TextColor.muted,
                ]),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _BlankChip(value: value.value, onDeleted: onRemove),
                ),
              ),
              Button.icon(
                tokens: tokens,
                icon: Icons.keyboard_arrow_up_rounded,
                onPressed: canMoveUp ? onMoveUp : null,
              ),
              Button.icon(
                tokens: tokens,
                icon: Icons.keyboard_arrow_down_rounded,
                onPressed: canMoveDown ? onMoveDown : null,
              ),
              Button.icon(
                tokens: tokens,
                icon: Icons.delete_rounded,
                onPressed: canRemove ? onRemove : null,
              ),
            ],
          ),
          SegmentedControl<CasingType>(
            isScrollable: true,
            value: value.casingType,
            options: [
              for (final type in CasingType.values)
                SegmentOption(value: type, label: type.label),
            ],
            onChanged: onCasingTypeChanged,
          ),
        ],
      ),
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
