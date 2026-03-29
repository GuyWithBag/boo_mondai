// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor/match_editor.dart
// PURPOSE: Match Madness editor with add/remove pair controls
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class MatchEditor extends StatelessWidget {
  const MatchEditor({
    super.key,
    required this.pairs,
    required this.onAdd,
    required this.onRemove,
    required this.onUpdate,
  });

  final List<Pair> pairs;
  final VoidCallback onAdd;
  final void Function(int) onRemove;
  final void Function(int, Pair) onUpdate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Match Pairs',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            FilledButton.tonal(
              onPressed: onAdd,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 16),
                  SizedBox(width: AppSpacing.xs),
                  Text('Add Pair'),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Each term will be matched to its corresponding answer',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.md),
        ...pairs.asMap().entries.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: MatchRow(
              index: e.key,
              pair: e.value,
              canRemove: pairs.length > 2,
              onRemove: () => onRemove(e.key),
              onChanged: (p) => onUpdate(e.key, p),
            ),
          ),
        ),
      ],
    );
  }
}
