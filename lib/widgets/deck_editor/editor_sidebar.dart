// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_editor/editor_sidebar.dart
// PURPOSE: Sidebar listing all cards in the deck with add button
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class EditorSidebar extends StatelessWidget {
  const EditorSidebar({
    super.key,
    required this.cards,
    required this.activeCardId,
    required this.isAdding,
    required this.onSelect,
    required this.onAdd,
  });

  final List<DeckCard> cards;
  final String? activeCardId;
  final bool isAdding;
  final void Function(String cardId) onSelect;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border(
          right: BorderSide(color: scheme.surfaceContainerHighest),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: "Cards (N)" + add button
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.xs,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Cards (${cards.length})',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: isAdding
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.add, size: 18),
                  tooltip: 'Add new card',
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  onPressed: isAdding ? null : onAdd,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: cards.isEmpty
                ? const Center(
                    child: Text(
                      'No cards yet',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: cards.length,
                    itemBuilder: (ctx, i) => SidebarItem(
                      card: cards[i],
                      isActive: cards[i].id == activeCardId,
                      onTap: () => onSelect(cards[i].id),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
