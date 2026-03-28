// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/deck_card_widget.dart
// PURPOSE: Reusable deck card for grid/list display with title, count, language, premade badge, selection mode
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/shared/shared.dart';

class DeckCardWidget extends StatelessWidget {
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

  const DeckCardWidget({
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
                  if (!isSelecting) ...[
                    if (deck.isPremade) const PremadeBadge(),
                    if (isDirty) _UnsyncedBadge(isPushing: isPushing),
                    if (onDelete != null || onPush != null)
                      _DeckPopupMenu(
                        onDelete: onDelete,
                        onPush: isPushing ? null : onPush,
                      ),
                  ],
                  if (isSelecting)
                    _SelectionIndicator(isSelected: isSelected),
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

class _DeckPopupMenu extends StatelessWidget {
  const _DeckPopupMenu({this.onDelete, this.onPush});
  final VoidCallback? onDelete;
  final VoidCallback? onPush;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      iconSize: 18,
      padding: EdgeInsets.zero,
      tooltip: 'Deck options',
      onSelected: (value) {
        if (value == 'push') onPush?.call();
        if (value == 'delete') onDelete?.call();
      },
      itemBuilder: (context) => [
        if (onPush != null)
          const PopupMenuItem(
            value: 'push',
            child: Row(
              children: [
                Icon(Icons.cloud_upload_outlined, size: 18),
                SizedBox(width: 8),
                Text('Push changes'),
              ],
            ),
          ),
        if (onDelete != null)
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete_outline, size: 18, color: Colors.red),
                SizedBox(width: 8),
                Text('Delete', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
      ],
    );
  }
}

class _UnsyncedBadge extends StatelessWidget {
  const _UnsyncedBadge({required this.isPushing});

  final bool isPushing;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isPushing ? 'Pushing to cloud…' : 'Unsynced local changes',
      child: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.xs),
        child: isPushing
            ? const SizedBox.square(
                dimension: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(
                Icons.cloud_upload_outlined,
                size: 16,
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.7),
              ),
      ),
    );
  }
}

class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? scheme.primary : Colors.transparent,
        border: Border.all(
          color: isSelected ? scheme.primary : AppColors.textSecondary,
          width: 2,
        ),
      ),
      child: isSelected
          ? Icon(Icons.check, size: 13, color: scheme.onPrimary)
          : null,
    );
  }
}

class PremadeBadge extends StatelessWidget {
  const PremadeBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadii.badge),
      ),
      child: const Text(
        'Premade',
        style: TextStyle(
          color: AppColors.secondary,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
