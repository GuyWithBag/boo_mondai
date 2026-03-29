// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/survey/proficiency_level_selector.dart
// PURPOSE: Radio group for selecting proficiency level in the screener survey
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class ProficiencyLevelSelector extends StatelessWidget {
  final String? value;
  final ValueChanged<String> onChanged;

  const ProficiencyLevelSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const _levels = [
    ('none', 'None — I have no prior knowledge'),
    ('beginner', 'Beginner — I know a few words or phrases'),
    ('elementary', 'Elementary — I can understand basic sentences'),
    ('intermediate', 'Intermediate — I can hold simple conversations'),
    ('advanced', 'Advanced — I am highly proficient'),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What is your current proficiency level in your target language?',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            RadioGroup<String>(
              groupValue: value,
              onChanged: (v) {
                if (v != null && v.isNotEmpty) onChanged(v);
              },
              child: Column(
                children: ProficiencyLevelSelector._levels
                    .map(
                      (level) => RadioListTile<String>(
                        value: level.$1,
                        title: Text(level.$2),
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
