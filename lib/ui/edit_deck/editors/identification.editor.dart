import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        AnswerKeyTile,
        Button,
        CardVerticalAlignmentControl,
        EditDeckController,
        EditDeckFormValidator,
        FormField,
        IdentificationAnswerKey,
        IdentificationEditorController,
        SectionEyebrow,
        SurfaceColor,
        TextColor,
        TextFieldCard,
        TextSize,
        TextWeight,
        surfaceStyle,
        textStyle;
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
                      AnswerKeyTile(
                        index: entry.key,
                        value: entry.value.value,
                        casingType: entry.value.casingType,
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
