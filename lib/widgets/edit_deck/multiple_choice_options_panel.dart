import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:theme_variants/theme_variants.dart';

import 'package:boo_mondai/shared/theme/theme.barrel.dart';
import '../../variant_styles/variant_styles.barrel.dart';
import '../../widgets/section_eyebrow.dart';
import '../../widgets/status_badge.dart';
import '../../widgets/tactile_button.dart';
import 'multiple_choice_option.dart' as editor;

class MultipleChoiceOptionsPanel extends StatelessWidget {
  const MultipleChoiceOptionsPanel({
    required this.options,
    required this.onOptionAdd,
    required this.onOptionRemove,
    required this.onOptionUpdate,
    super.key,
  });

  final List<MultipleChoiceOptionData> options;
  final VoidCallback onOptionAdd;
  final ValueChanged<int> onOptionRemove;
  final void Function(int index, MultipleChoiceOptionData option)
  onOptionUpdate;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Surface(
      style: surfaceStyle.resolve(tokens, const [SurfaceTone.surface]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(child: SectionEyebrow('Answer Options')),
              const StatusBadge(label: 'Select correct'),
            ],
          ),
          const SizedBox(height: 22),
          Expanded(
            child: ListView(
              children: [
                for (final entry in options.asMap().entries) ...[
                  editor.EditMultipleChoiceOption(
                    value: entry.value.text,
                    correct: entry.value.isCorrect,
                    showRadio: true,
                    canRemove: options.length > 2,
                    onCorrectChanged: () {
                      for (var i = 0; i < options.length; i++) {
                        onOptionUpdate(
                          i,
                          MultipleChoiceOptionData(
                            text: options[i].text,
                            isCorrect: i == entry.key,
                          ),
                        );
                      }
                    },
                    onTextChanged: (value) => onOptionUpdate(
                      entry.key,
                      MultipleChoiceOptionData(
                        text: value,
                        isCorrect: entry.value.isCorrect,
                      ),
                    ),
                    onRemove: () => onOptionRemove(entry.key),
                  ),
                  const SizedBox(height: 14),
                ],
              ],
            ),
          ),
          if (options.length < 6) ...[
            const SizedBox(height: 20),
            TactileButton(
              leading: const Icon(Icons.add),
              tone: TactileTone.dashed,
              onPressed: onOptionAdd,
              child: const Text('Add Option'),
            ),
          ],
        ],
      ),
    );
  }
}
