// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/view_deck_page.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/controllers/view_decks.local.controller.dart';
import 'package:boo_mondai/database/database.barrel.dart';

import 'package:boo_mondai/services/services.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:provider/provider.dart';

class ViewDeckLocalPage extends HookWidget {
  final String deckId;
  const ViewDeckLocalPage({super.key, required this.deckId});

  @override
  Widget build(BuildContext context) {
    final currentDeck = LocalDB.deck.selectByPk({'id': deckId});

    final cachedProfsRepo = LocalDB.cachedProfile;
    final author = cachedProfsRepo.selectByPk({'id': currentDeck!.userId});
    final sourceAuthor = null;

    final controller = context.read<ViewDecksLocalController>();

    // ── Calculate drill eligibility (works in guest mode too) ──────────────
    final userId = LocalDB.profile.getOrCreate().userId;
    final eligibleCards = DrillService.getEligibleDrillCards(deckId, userId);

    final availableCount = eligibleCards.length;
    final canDrill = availableCount > 0;
    // ─────────────────────────────────────────────────────────

    String getStartDrillButtonText() {
      if (currentDeck.cardCount == 0) {
        return 'No cards yet';
      }
      return canDrill ? 'Start Drill ($availableCount)' : 'Completed';
    }

    Future<void> deleteDeckDialog() async {
      final title = currentDeck.title;
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
      if (confirmed == true) {
        await controller.deleteDeck(deckId);
        if (context.mounted) context.pop();
      }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/decks-local/$deckId/edit'),
        child: const Icon(Icons.edit_rounded),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.push('/drill/$deckId/preview'),
                child: const Text('Preview'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: FilledButton(
                // Disable the button if there are no eligible cards
                onPressed: canDrill
                    ? () => context.go('/drill/$deckId/session')
                    : null,
                child: Text(getStartDrillButtonText()),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(currentDeck.title),
        actions: [
          IconButton(
            onPressed: deleteDeckDialog,
            icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
          ),
        ],
      ),
      body: DeckDetails(
        deck: currentDeck,
        author: author,
        sourceAuthor: sourceAuthor,
      ),
    );
  }
}
