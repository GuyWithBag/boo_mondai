// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/deck_editor/mc_panel.dart
// PURPOSE: Multiple choice options panel with add/remove/toggle correct
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';

/// A container for managing multiple-choice options, including adding,
/// removing, and toggling the "correct" status of each option.
class McPanel extends StatelessWidget {
  const McPanel({
    super.key,
    required this.options,
    required this.onOptionAdd,
    required this.onOptionRemove,
    required this.onOptionUpdate,
  });

  /// The list of multiple-choice options currently defined for this card.
  final List<MultipleChoiceOptionData> options;

  /// Callback to add a new blank multiple-choice option.
  final VoidCallback onOptionAdd;

  /// Callback to remove a multiple-choice option at a specific index.
  final void Function(int index) onOptionRemove;

  /// Callback to update a specific multiple-choice option.
  final void Function(int index, MultipleChoiceOptionData updatedOption)
  onOptionUpdate;

  @override
  Widget build(BuildContext context) {
    final themeColorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: themeColorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: themeColorScheme.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'ANSWER OPTIONS',
                style: textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
              const Spacer(),

              // We limit to 6 options for UI consistency.
              if (options.length < 6)
                TextButton.icon(
                  onPressed: onOptionAdd,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Render each option as an McRow.
          ...options.asMap().entries.map((entry) {
            final index = entry.key;
            final optionData = entry.value;

            return McRow(
              index: index,
              option: optionData,
              canRemove: options.length > 2,
              onRemove: () => onOptionRemove(index),
              onChanged: (updatedOption) =>
                  onOptionUpdate(index, updatedOption),
            );
          }),
        ],
      ),
    );
  }
}
