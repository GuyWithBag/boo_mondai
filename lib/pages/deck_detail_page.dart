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
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/providers/providers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class DeckDetailPage extends HookWidget {
  final String deckId;
  const DeckDetailPage({super.key, required this.deckId});

  @override
  Widget build(BuildContext context) {
    final cardProvider = context.watch<CardProvider>();
    final deckProvider = context.watch<DeckProvider>();
    final scrollController = useScrollController();
    final selectedIds = useState<Set<String>>({});

    final deck = deckProvider.userDecks
        .where((d) => d.id == deckId)
        .firstOrNull;

    final isSelecting = selectedIds.value.isNotEmpty;

    useEffect(() {
      final provider = context.read<CardProvider>();
      // Skip Supabase fetch if cards for this deck are already in memory
      // (e.g. returning from the editor with unsaved local changes).
      if (provider.currentDeckId == deckId && provider.cards.isNotEmpty) {
        return null;
      }
      Future.microtask(() => provider.fetchCards(deckId));
      return null;
    }, [deckId]);

    // Show a snackbar whenever an error is set on CardProvider
    useEffect(() {
      void listener() {
        final err = context.read<CardProvider>().error;
        if (err != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(err),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              context.read<CardProvider>().clearError();
            }
          });
        }
      }

      final provider = context.read<CardProvider>();
      provider.addListener(listener);
      return () => provider.removeListener(listener);
    }, const []);

    Future<void> confirmDeleteDeck() async {
      final deckProv = context.read<DeckProvider>();
      final title = deck?.title ?? 'this deck';
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete deck?'),
          content: Text('"$title" and all its cards will be removed.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      if (confirmed == true && context.mounted) {
        await deckProv.deleteDeck(deckId);
        if (context.mounted) context.pop();
      }
    }

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
          ? SelectionAppBar(
              count: selectedIds.value.length,
              onCancel: () => selectedIds.value = {},
              onDelete: deleteSelected,
            )
          : AppBar(
              title: const Text('Deck'),
              actions: [
                if (cardProvider.isDirty(deckId))
                  Tooltip(
                    message: cardProvider.isPushing
                        ? 'Pushing…'
                        : 'Push local changes to cloud',
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                      ),
                      child: TextButton.icon(
                        onPressed: cardProvider.isPushing
                            ? null
                            : () =>
                                  context.read<CardProvider>().pushDeck(deckId),
                        icon: cardProvider.isPushing
                            ? const SizedBox.square(
                                dimension: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.cloud_upload_outlined, size: 18),
                        label: const Text('Push'),
                      ),
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit deck',
                  onPressed: () => context.push('/my-decks/$deckId/edit'),
                ),
                PopupMenuButton<String>(
                  tooltip: 'More options',
                  onSelected: (value) {
                    if (value == 'delete') confirmDeleteDeck();
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.red,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Delete deck',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
      floatingActionButton: !isSelecting && cardProvider.cards.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => context.push('/my-decks/$deckId/cards/edit'),
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
              onAction: () => context.push('/my-decks/$deckId/cards/edit'),
            )
          : ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: cardProvider.cards.length,
              itemBuilder: (context, i) {
                final card = cardProvider.cards[i];
                return CardTile(
                  card: card,
                  isSelecting: isSelecting,
                  isSelected: selectedIds.value.contains(card.id),
                  isUneditable: deck?.isUneditable ?? false,
                  onTap: () => isSelecting
                      ? toggleSelection(card.id)
                      : context.push(
                          '/my-decks/$deckId/cards/edit?cardId=${card.id}',
                        ),
                  onLongPress: () => toggleSelection(card.id),
                );
              },
            ),
    );
  }
}
