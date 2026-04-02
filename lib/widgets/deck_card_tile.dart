// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/deck_card_widget.dart
// PURPOSE: Reusable deck card for grid/list display with title, count, language, premade badge, selection mode
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class DeckCardTile extends StatelessWidget {
  final Deck deck;

  /// When non-null, a delete option appears in the card's popup menu.
  final VoidCallback? onDelete;

  /// When non-null, a "Push changes" option appears in the popup menu.
  final VoidCallback? onPush;

  /// Shows a small "unsynced" badge on the card when true.
  final bool isDirty;

  /// Shows a spinner badge instead of the cloud icon while push is in progress.
  final bool isPushing;

  /// Whether the grid is currently in multi-select mode.
  final bool isSelecting;

  /// Whether this specific card is selected.
  final bool isSelected;

  /// Called when the card is tapped in selection mode.
  final VoidCallback? onSelect;

  /// Called when the card is long-pressed (triggers selection mode entry).
  final VoidCallback? onLongPress;

  const DeckCardTile({
    super.key,
    required this.deck,
    this.onDelete,
    this.onPush,
    this.isDirty = false,
    this.isPushing = false,
    this.isSelecting = false,
    this.isSelected = false,
    this.onSelect,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: isSelected ? scheme.primaryContainer : null,
      child: InkWell(
        onTap: isSelecting
            ? onSelect
            : () => context.push('/my-decks/${deck.id}'),
        onLongPress: !isSelecting ? onLongPress : null,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      deck.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    deck.id,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (!isSelecting) ...[
                    if (deck.isPremade) const StatusBadge.premade(),
                    if (isDirty) UnsyncedBadge(isPushing: isPushing),
                    if (onDelete != null || onPush != null)
                      DeckPopupMenu(
                        onDelete: onDelete,
                        onPush: isPushing ? null : onPush,
                      ),
                  ],
                  if (isSelecting) SelectionIndicator(isSelected: isSelected),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${deck.cardCount} cards  ·  ${deck.targetLanguage}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
