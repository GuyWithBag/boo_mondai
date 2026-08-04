import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        CardTemplateFormState,
        CardVerticalAlignmentControl,
        CasingType,
        EditDeckFormValidator,
        FormField,
        IdentificationAnswerData,
        MarkdownText,
        MarkdownTextMode,
        SectionEyebrow,
        SegmentOption,
        SegmentedControl,
        SurfaceBorder,
        SurfaceColor,
        SurfacePadding,
        SurfaceShadow,
        TextColor,
        TextFieldCard,
        TextFieldFrame,
        TextFieldSize,
        TextSize,
        TextWeight,
        surfaceStyle,
        textStyle,
        useIdentificationEditor;
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class IdentificationEditor extends HookWidget {
  const IdentificationEditor({required this.formState, super.key});

  final CardTemplateFormState formState;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final editor = useIdentificationEditor(formState);

    return Column(
      spacing: tokens.spaceLayoutGapMd,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CardVerticalAlignmentControl(formState: formState),
        FormField<String>(
          value: editor.promptController.text,
          listenable: editor.promptController,
          valueReader: () => editor.promptController.text,
          validator: EditDeckFormValidator.prompt,
          builder: (_, field) => TextFieldCard(
            title: 'Prompt',
            placeholder: 'Type the identification question...',
            controller: editor.promptController,
            onChanged: field.didChange,
          ),
        ),
        FormField<List<IdentificationAnswerData>>(
          value: editor.answers,
          listenable: formState.identificationAnswers,
          valueReader: () => formState.identificationAnswers.value,
          validator: EditDeckFormValidator.identificationAnswers,
          builder: (_, _) => Surface(
            style: surfaceStyle.resolve(tokens, const [SurfaceColor.baseline]),
            child: Column(
              spacing: tokens.spaceLayoutGapMd,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SectionEyebrow('Accepted Answers'),
                    Text(
                      'Ordered',
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
                    for (final entry in editor.answers.asMap().entries)
                      _IdentificationAnswerRow(
                        index: entry.key,
                        value: entry.value,
                        canMoveUp: entry.key > 0,
                        canMoveDown: entry.key < editor.answers.length - 1,
                        canRemove: editor.answers.length > 1,
                        onAnswerChanged: (value) =>
                            editor.updateAnswer(entry.key, value),
                        onCasingTypeChanged: (value) =>
                            editor.updateCasingType(entry.key, value),
                        onMoveUp: () => editor.moveAnswerUp(entry.key),
                        onMoveDown: () => editor.moveAnswerDown(entry.key),
                        onRemove: () => editor.removeAnswer(entry.key),
                      ),
                  ],
                ),
                Button.dashed(
                  tokens: tokens,
                  leading: const Icon(Icons.add),
                  onPressed: editor.addAnswer,
                  child: const Text('Add Answer'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _IdentificationAnswerRow extends StatelessWidget {
  const _IdentificationAnswerRow({
    required this.index,
    required this.value,
    required this.canMoveUp,
    required this.canMoveDown,
    required this.canRemove,
    required this.onAnswerChanged,
    required this.onCasingTypeChanged,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onRemove,
  });

  final int index;
  final IdentificationAnswerData value;
  final bool canMoveUp;
  final bool canMoveDown;
  final bool canRemove;
  final ValueChanged<String> onAnswerChanged;
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
                child: MarkdownText(
                  data: value.answer,
                  onChanged: onAnswerChanged,
                  mode: MarkdownTextMode.input,
                  placeholder: 'Accepted answer...',
                  variants: const [
                    TextFieldSize.labelLarge,
                    TextFieldFrame.outline,
                  ],
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
