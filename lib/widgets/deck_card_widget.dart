// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/deck_card_widget.dart
// PURPOSE: Reusable deck card for grid/list display with title, count, language, premade badge
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:boo_mondai/models/models.dart';
import 'package:boo_mondai/shared/shared.dart';

class DeckCardWidget extends StatelessWidget {
  final Deck deck;

  const DeckCardWidget({super.key, required this.deck});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => context.push('/decks/${deck.id}'),
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
                  if (deck.isPremade) const PremadeBadge(),
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
