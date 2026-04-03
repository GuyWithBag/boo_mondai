// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/view_deck_page.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/repositories/repositories.barrel.dart';
import 'package:boo_mondai/services/services.barrel.dart'; // <-- Ensure services are imported
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';

class ViewDeckPage extends HookWidget {
  final String? deckId;
  const ViewDeckPage({super.key, required this.deckId});

  @override
  Widget build(BuildContext context) {
    if (deckId == null) {
      return Center(child: ErrorText('Error 404: deck Id not found'));
    }

    final deckRepo = Repositories.deck;
    final currentDeck = deckRepo.getById(deckId!);
    final cachedProfsRepo = Repositories.cachedProfile;
    final author = cachedProfsRepo.getById(currentDeck!.authorId);
    final sourceAuthor = cachedProfsRepo.getById(
      currentDeck.sourceAuthorId ?? '',
    );

    // ── NEW: Calculate Eligibility ───────────────────────────
    final userId = Services.auth.currentUser!.id;
    final eligibleCards = QuizService.getEligibleQuizCards(deckId!, userId);
    final availableCount = eligibleCards.length;
    final canQuiz = availableCount > 0;
    // ─────────────────────────────────────────────────────────

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
      if (confirmed == true && context.mounted) {
        // await deckProv.deleteDeck(deckId);
        if (context.mounted) context.pop();
      }
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/my-decks/$deckId/edit'),
        child: const Icon(Icons.edit_rounded),
      ),
      bottomNavigationBar: Padding(
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
                // Disable the button if there are no eligible cards
                onPressed: canQuiz
                    ? () => context.go('/quiz/$deckId/session')
                    : null,
                child: Text(
                  canQuiz ? 'Start Quiz ($availableCount)' : 'Completed',
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(currentDeck.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit deck',
            onPressed: () => context.push('/my-decks/$deckId/edit'),
          ),
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
