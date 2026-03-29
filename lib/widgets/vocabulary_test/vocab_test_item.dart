// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/vocabulary_test/vocab_test_item.dart
// PURPOSE: Card widget for a single vocabulary test question with radio options
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class VocabTestItem extends StatelessWidget {
  final int index;
  final VocabTestItemData item;
  final String? selectedOption;
  final ValueChanged<String> onSelected;

  const VocabTestItem({
    super.key,
    required this.index,
    required this.item,
    this.selectedOption,
    required this.onSelected,
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
              '$index. ${item.prompt}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            RadioGroup<String>(
              groupValue: selectedOption,
              onChanged: (v) {
                if (v != null && v.isNotEmpty) onSelected(v);
              },
              child: Column(
                children: item.options.entries
                    .map(
                      (e) => RadioListTile<String>(
                        value: e.key,
                        title: Text('${e.key}) ${e.value}'),
                        dense: true,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
