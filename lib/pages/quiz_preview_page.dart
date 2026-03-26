// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/quiz_preview_page.dart
// PURPOSE: Preview vocabulary cards before starting a quiz session
// PROVIDERS: CardProvider, AuthProvider, QuizProvider
// HOOKS: useEffect, useScrollController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/providers/auth_provider.dart';
import 'package:boo_mondai/providers/card_provider.dart';
import 'package:boo_mondai/providers/quiz_provider.dart';
import 'package:boo_mondai/shared/app_spacing.dart';

class QuizPreviewPage extends HookWidget {
  const QuizPreviewPage({super.key, required this.deckId});

  final String deckId;

  @override
  Widget build(BuildContext context) {
    final cardProvider = context.watch<CardProvider>();
    final scrollController = useScrollController();

    useEffect(() {
      if (cardProvider.currentDeckId != deckId) {
        Future.microtask(
            () => context.read<CardProvider>().fetchCards(deckId));
      }
      return null;
    }, [deckId]);

    return Scaffold(
      appBar: AppBar(title: const Text('Preview Cards')),
      body: SafeArea(
        child: cardProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : cardProvider.cards.isEmpty
                ? const Center(child: Text('No cards in this deck'))
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(AppSpacing.md),
                          itemCount: cardProvider.cards.length,
                          itemBuilder: (context, i) {
                            final card = cardProvider.cards[i];
                            return PreviewCardTile(
                              index: i + 1,
                              question: card.question,
                              answer: card.answer,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        child: SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: () async {
                              final auth = context.read<AuthProvider>();
                              final userId = auth.userProfile?.id;
                              if (userId == null) return;

                              await context.read<QuizProvider>().startSession(
                                    deckId,
                                    userId,
                                    cardProvider.cards,
                                    true,
                                  );
                              if (context.mounted) {
                                context.go('/quiz/$deckId/session');
                              }
                            },
                            child: const Text('Start Quiz'),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class PreviewCardTile extends StatelessWidget {
  final int index;
  final String question;
  final String answer;

  const PreviewCardTile({
    super.key,
    required this.index,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              child: Text('$index', style: const TextStyle(fontSize: 12)),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    answer,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
