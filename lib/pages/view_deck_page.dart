// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/view_deck_page.dart
// PURPOSE: View a deck's cards and start quiz or preview
// PROVIDERS: ViewDeckController, DeckProvider
// HOOKS: useEffect, useScrollController, useState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/providers/providers.barrel.dart';
import 'package:boo_mondai/services/services.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class ViewDeckPage extends HookWidget {
  final String deckId;
  const ViewDeckPage({super.key, required this.deckId});

  @override
  Widget build(BuildContext context) {
    final vdc = context.watch<ViewDeckController>();
    final deckProvider = context.watch<DeckProvider>();
    final scrollController = useScrollController();
    final selectedIds = useState<Set<String>>({});

    final deck = vdc.currentDeck;
    final isSelecting = selectedIds.value.isNotEmpty;

    // Profile info for DeckDetails — Hive first, Supabase fallback
    final authorProfile = useState<ProfileInfo?>(null);
    final originalAuthorProfile = useState<ProfileInfo?>(null);

    // Load deck + cards from Hive into ViewDeckController on mount
    useEffect(() {
      Future.microtask(
        () => vdc.loadDeck(deckId, fromDecks: deckProvider.userDecks),
      );
      return null;
    }, [deckId]);

    // Fetch author profiles: Hive cache first, Supabase fallback + cache
    useEffect(() {
      if (deck == null) return null;
      final hive = context.read<HiveService>();

      ProfileInfo? resolveProfile(String userId) {
        final cached = hive.getProfileInfo(userId);
        return cached;
      }

      Future.microtask(() {
        authorProfile.value = resolveProfile(deck.creatorId);
        if (deck.sourceDeckCreatorId != null) {
          originalAuthorProfile.value = resolveProfile(
            deck.sourceDeckCreatorId!,
          );
        }
      });
      return null;
    }, [deck?.creatorId, deck?.sourceDeckCreatorId]);

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

    void deleteSelected() {
      final toDelete = {...selectedIds.value};
      selectedIds.value = {};
      final controller = context.read<ViewDeckController>();
      for (final id in toDelete) {
        controller.deleteCard(id);
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
                if (vdc.isDirty)
                  Tooltip(
                    message: 'Unsaved changes',
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                      ),
                      child: TextButton.icon(
                        onPressed: () async {
                          await context.read<ViewDeckController>().save();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Saved')),
                            );
                          }
                        },
                        icon: const Icon(Icons.save_outlined, size: 18),
                        label: const Text('Save'),
                      ),
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit deck',
                  onPressed: () => context.push('/my-decks/$deckId/cards/edit'),
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
      floatingActionButton: !isSelecting && vdc.cards.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => context.push('/my-decks/$deckId/cards/edit'),
              child: const Icon(Icons.edit_rounded),
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
      body: deck == null
          ? const Center(child: CircularProgressIndicator())
          : DeckDetails(
              deck: deck,
              authorProfile: authorProfile.value,
              originalAuthorProfile: originalAuthorProfile.value,
            ),
    );
  }
}
