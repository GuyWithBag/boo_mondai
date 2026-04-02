// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/deck_editor/match_editor.dart
// PURPOSE: Match Madness editor with add/remove pair controls
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';

/// A specialized editor for "Match Madness" cards.
class MatchEditor extends StatelessWidget {
  const MatchEditor({
    super.key,
    required this.matchingPairs,
    required this.onPairAdd,
    required this.onPairRemove,
    required this.onPairUpdate,
  });

  /// The list of term-match pairs for this card.
  final List<MatchPairData> matchingPairs;

  /// Callback to add a new blank pair.
  final VoidCallback onPairAdd;

  /// Callback to remove a pair at a specific index.
  final void Function(int index) onPairRemove;

  /// Callback to update a specific pair.
  final void Function(int index, MatchPairData updatedPair) onPairUpdate;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Match Pairs',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            FilledButton.tonal(
              onPressed: onPairAdd,
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
          'Each term will be matched to its corresponding answer during the game.',
          style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.md),

        // Display each pair as a row with input fields.
        ...matchingPairs.asMap().entries.map((entry) {
          final index = entry.key;
          final pairData = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: MatchRow(
              index: index,
              pair: pairData,
              canRemove: matchingPairs.length > 2,
              onRemove: () => onPairRemove(index),
              onChanged: (updatedPair) => onPairUpdate(index, updatedPair),
            ),
          );
        }),
      ],
    );
  }
}
