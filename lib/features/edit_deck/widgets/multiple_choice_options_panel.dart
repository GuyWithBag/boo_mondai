import 'package:boo_mondai/lib.barrel.dart';
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class MultipleChoiceOptionsPanel extends StatelessWidget {
  const MultipleChoiceOptionsPanel({required this.controller, super.key});

  final MultipleChoiceEditorController controller;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final options = controller.options;

    return Surface(
      style: surfaceStyle.resolve(tokens),
      child: Column(
        spacing: tokens.spaceLayoutGapMd,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SectionEyebrow('Answer Options'),
              ChipTheme(
                data: chipStyle.resolve(tokens, const [ChipTone.filled]),
                child: const Chip(label: Text('Select correct')),
              ),
            ],
          ),
          Column(
            children: [
              for (final option in options.asMap().entries) ...[
                EditMultipleChoiceOption(
                  value: option.value.text,
                  correct: option.value.isCorrect,
                  showRadio: true,
                  canRemove: options.length > 2,
                  onCorrectChanged: () =>
                      controller.selectCorrectOption(option.key),
                  onTextChanged: (value) =>
                      controller.updateOptionText(option.key, value),
                  onRemove: () => controller.removeOption(option.key),
                ),
                const SizedBox(height: 14),
              ],
            ],
          ),
          Button.dashed(
            tokens: tokens,
            leading: const Icon(Icons.add),
            onPressed: controller.addOption,
            child: const Text('Add Option'),
          ),
        ],
      ),
    );
  }
}
