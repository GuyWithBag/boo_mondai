// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_detail_page.dart
// PURPOSE: View a deck's cards and start quiz or preview
// PROVIDERS: CardProvider, DeckProvider
// HOOKS: useEffect, useScrollController, useState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/providers/providers.dart';
import 'package:boo_mondai/shared/shared.dart';
import 'package:boo_mondai/widgets/widgets.dart';

class DeckDetailPage extends HookWidget {
  final String deckId;
  const DeckDetailPage({super.key, required this.deckId});

  @override
  Widget build(BuildContext context) {
    final cardProvider = context.watch<CardProvider>();
    final scrollController = useScrollController();
    final selectedIds = useState<Set<String>>({});

    final isSelecting = selectedIds.value.isNotEmpty;

    useEffect(() {
      final provider = context.read<CardProvider>();
      Future.microtask(() => provider.fetchCards(deckId));
      return null;
    }, [deckId]);

    Future<void> deleteSelected() async {
      final toDelete = {...selectedIds.value};
      selectedIds.value = {};
      final provider = context.read<CardProvider>();
      for (final id in toDelete) {
        await provider.deleteCard(id);
      }
    }

    void toggleSelection(String id) {
      final next = {...selectedIds.value};
      if (next.contains(id)) {
        next.remove(id);
      } else {
        next.add(id);
      }
      selectedIds.value = next;
    }

    return Scaffold(
      appBar: isSelecting
          ? _SelectionAppBar(
              count: selectedIds.value.length,
              onCancel: () => selectedIds.value = {},
              onDelete: deleteSelected,
            )
          : AppBar(
              title: const Text('Deck'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit deck',
                  onPressed: () => context.push('/decks/$deckId/edit'),
                ),
              ],
            ),
      floatingActionButton: !isSelecting && cardProvider.cards.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => context.push('/decks/$deckId/cards/add'),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: isSelecting
          ? null
          : Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.push('/quiz/$deckId/preview'),
                      child: const Text('Preview'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => context.go('/quiz/$deckId/session'),
                      child: const Text('Start Quiz'),
                    ),
                  ),
                ],
              ),
            ),
      body: cardProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : cardProvider.cards.isEmpty
          ? EmptyStateWidget(
              icon: Icons.style_outlined,
              title: 'No cards yet',
              actionLabel: 'Add Card',
              onAction: () => context.push('/decks/$deckId/cards/add'),
            )
          : ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: cardProvider.cards.length,
              itemBuilder: (context, i) {
                final card = cardProvider.cards[i];
                return _CardTile(
                  card: card,
                  isSelecting: isSelecting,
                  isSelected: selectedIds.value.contains(card.id),
                  onTap: () => isSelecting
                      ? toggleSelection(card.id)
                      : context.push('/decks/$deckId/cards/${card.id}/edit'),
                  onLongPress: () => toggleSelection(card.id),
                );
              },
            ),
    );
  }
}

// ── Selection app bar ─────────────────────────────────────────────

class _SelectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _SelectionAppBar({
    required this.count,
    required this.onCancel,
    required this.onDelete,
  });

  final int count;
  final VoidCallback onCancel;
  final VoidCallback onDelete;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AppBar(
      backgroundColor: scheme.primaryContainer,
      leading: IconButton(
        icon: const Icon(Icons.close),
        tooltip: 'Cancel selection',
        onPressed: onCancel,
      ),
      title: Text(
        '$count selected',
        style: TextStyle(color: scheme.onPrimaryContainer),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Delete selected',
          color: scheme.error,
          onPressed: onDelete,
        ),
      ],
    );
  }
}

// ── Card tile ─────────────────────────────────────────────────────

class _CardTile extends StatelessWidget {
  const _CardTile({
    required this.card,
    required this.isSelecting,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  final DeckCard card;
  final bool isSelecting;
  final bool isSelected;
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
        title: card.answer.isNotEmpty
            ? Text(card.question)
            : Text('This is has no question'),
        subtitle: card.answer.isNotEmpty
            ? Text(card.answer)
            : Text('This is has no answer'),
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
