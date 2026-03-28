// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor/direction_bar.dart
// PURPOSE: Card direction selector (normal, reversed, both) using SegmentedButton
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/shared/shared.dart';

class DirectionBar extends StatelessWidget {
  const DirectionBar({super.key, required this.selected, required this.onChanged});

  final CardType selected;
  final void Function(CardType) onChanged;

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
          Text(
            'Card Direction',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Choose how this card will be quizzed',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          SegmentedButton<CardType>(
            segments: const [
              ButtonSegment(
                  value: CardType.normal,
                  label: Text('Normal'),
                  icon: Icon(Icons.arrow_forward, size: 16)),
              ButtonSegment(
                  value: CardType.reversed,
                  label: Text('Reversed'),
                  icon: Icon(Icons.swap_horiz, size: 16)),
              ButtonSegment(
                  value: CardType.both,
                  label: Text('Both'),
                  icon: Icon(Icons.sync_alt, size: 16)),
            ],
            selected: {selected},
            onSelectionChanged: (s) => onChanged(s.first),
          ),
        ],
      ),
    );
  }
}
