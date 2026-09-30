import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        CardVerticalAlignmentControl,
        CasingType,
        EditDeckController,
        EditDeckFormValidator,
        FormField,
        IdentificationEditorController,
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
        IdentificationAnswerKey;
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_hooks/flutter_hooks.dart' show useEffect, useMemoized;
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class IdentificationEditor extends SignalHookWidget {
  const IdentificationEditor({required this.editDeckController, super.key});

  final EditDeckController editDeckController;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final controller = useMemoized(
      () => IdentificationEditorController(
        editDeckController: editDeckController,
      ),
      [editDeckController.selectedTemplateKey.value],
    );
    useEffect(() => controller.dispose, [controller]);
    final answers = controller.answers.value;

    return Column(
      spacing: tokens.spaceLayoutGapMd,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FormField<String>(
          value: controller.promptController.text,
          validator: EditDeckFormValidator.prompt,
          builder: (_, field) => TextFieldCard(
            title: 'Prompt',
            placeholder: 'Type the identification question...',
            controller: controller.promptController,
            onChanged: (value) {
              field.didChange(value);
              controller.updatePrompt(value);
            },
          ),
        ),
        FormField<List<IdentificationAnswerKey>>(
          value: answers,
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
                    for (final entry in answers.asMap().entries)
                      _IdentificationAnswerKeyRow(
                        index: entry.key,
                        answerKey: entry.value,
                        canMoveUp: entry.key > 0,
                        canMoveDown: entry.key < answers.length - 1,
                        canRemove: answers.length > 1,
                        onAnswerChanged: (value) =>
                            controller.updateAnswer(entry.key, value),
                        onCasingTypeChanged: (value) =>
                            controller.updateCasingType(entry.key, value),
                        onMoveUp: () => controller.moveAnswerUp(entry.key),
                        onMoveDown: () => controller.moveAnswerDown(entry.key),
                        onRemove: () => controller.removeAnswer(entry.key),
                      ),
                  ],
                ),
                Button.dashed(
                  tokens: tokens,
                  leading: const Icon(Icons.add),
                  onPressed: controller.addAnswer,
                  child: const Text('Add Answer'),
                ),
              ],
            ),
          ),
        ),
        CardVerticalAlignmentControl(
          value: controller.template.verticallyCentered,
          onChanged: controller.onVerticalAlignmentControlChanged,
        ),
      ],
    );
  }
}

class _IdentificationAnswerKeyRow extends StatelessWidget {
  const _IdentificationAnswerKeyRow({
    required this.index,
    required this.answerKey,
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
  final IdentificationAnswerKey answerKey;
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
                  data: answerKey.value,
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
            value: answerKey.casingType,
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
