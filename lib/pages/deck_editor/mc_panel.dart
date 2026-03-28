// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor/mc_panel.dart
// PURPOSE: Multiple choice options panel with add/remove/toggle correct
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.dart';
import 'package:boo_mondai/pages/deck_editor/editor_types.dart';
import 'package:boo_mondai/pages/deck_editor/mc_row.dart';

class McPanel extends StatelessWidget {
  const McPanel({
    super.key,
    required this.options,
    required this.onAdd,
    required this.onRemove,
    required this.onUpdate,
  });

  final List<McOpt> options;
  final VoidCallback onAdd;
  final void Function(int) onRemove;
  final void Function(int, McOpt) onUpdate;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: scheme.surfaceContainerHighest),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'ANSWER OPTIONS',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
              ),
              const Spacer(),
              if (options.length < 6)
                TextButton.icon(
                  onPressed: onAdd,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add'),
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...options.asMap().entries.map(
                (e) => McRow(
                  index: e.key,
                  option: e.value,
                  canRemove: options.length > 2,
                  onRemove: () => onRemove(e.key),
                  onChanged: (o) => onUpdate(e.key, o),
                ),
              ),
        ],
      ),
    );
  }
}
