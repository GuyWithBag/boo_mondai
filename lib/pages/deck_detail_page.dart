// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/deck_detail_page.dart
// PURPOSE: View a deck's cards and start quiz or preview
// PROVIDERS: CardProvider, DeckProvider
// HOOKS: useEffect, useScrollController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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

    useEffect(() {
      Future.microtask(() => context.read<CardProvider>().fetchCards(deckId));
      return null;
    }, [deckId]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deck'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit deck',
            onPressed: () => context.push('/decks/$deckId/edit'),
          ),
        ],
      ),
      floatingActionButton: cardProvider.cards.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => context.push('/decks/$deckId/cards/add'),
              child: const Icon(Icons.add),
            )
          : null,
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
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    itemCount: cardProvider.cards.length,
                    itemBuilder: (context, i) {
                      final card = cardProvider.cards[i];
                      return Card(
                        child: ListTile(
                          title: Text(card.question),
                          subtitle: Text(card.answer),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => context.push(
                              '/decks/$deckId/cards/${card.id}/edit',
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
