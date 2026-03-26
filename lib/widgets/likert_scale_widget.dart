// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/likert_scale_widget.dart
// PURPOSE: Reusable Likert scale question with numbered ChoiceChips
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/app_spacing.dart';

class LikertScaleWidget extends StatelessWidget {
  final int index;
  final String statement;
  final int? value;
  final int maxValue;
  final ValueChanged<int> onChanged;
  final String lowLabel;
  final String highLabel;

  const LikertScaleWidget({
    super.key,
    required this.index,
    required this.statement,
    this.value,
    this.maxValue = 5,
    required this.onChanged,
    this.lowLabel = 'Strongly\nDisagree',
    this.highLabel = 'Strongly\nAgree',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$index. $statement',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Text(lowLabel,
                    style: const TextStyle(fontSize: 10),
                    textAlign: TextAlign.center),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(maxValue, (i) {
                      final rating = i + 1;
                      return ChoiceChip(
                        label: Text('$rating'),
                        selected: value == rating,
                        onSelected: (_) => onChanged(rating),
                      );
                    }),
                  ),
                ),
                Text(highLabel,
                    style: const TextStyle(fontSize: 10),
                    textAlign: TextAlign.center),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
