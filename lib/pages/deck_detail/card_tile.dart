// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_detail/card_tile.dart
// PURPOSE: List tile for a card in the deck detail view with selection support
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/shared/shared.dart';
import 'package:boo_mondai/widgets/widgets.dart';

class CardTile extends StatelessWidget {
  const CardTile({
    super.key,
    required this.card,
    required this.isSelecting,
    required this.isSelected,
    required this.isUneditable,
    required this.onTap,
    required this.onLongPress,
  });

  final DeckCard card;
  final bool isSelecting;
  final bool isSelected;
  final bool isUneditable;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: isSelected ? scheme.primaryContainer : null,
      child: ListTile(
        leading: isSelecting
            ? AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? scheme.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? scheme.primary
                        : AppColors.textSecondary,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Icon(Icons.check, size: 14, color: scheme.onPrimary)
                    : null,
              )
            : null,
        title: Row(
          children: [
            Expanded(
              child: Text(
                card.question.isNotEmpty ? card.question : '(no question)',
              ),
            ),
            if (isUneditable) ...[
              const SizedBox(width: AppSpacing.xs),
              StatusBadge.uneditable(),
            ],
          ],
        ),
        subtitle: Text(
          card.answer.isNotEmpty ? card.answer : '(no answer)',
        ),
        trailing: isSelecting
            ? null
            : IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: onTap,
              ),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
