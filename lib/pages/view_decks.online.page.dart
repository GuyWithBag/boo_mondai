// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/view_decks_online_page.dart
// PURPOSE: Browse all public user-created decks with tag filters
// HOOKS: useEffect, useTextEditingController, useState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:flutter/material.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';
import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

import 'view_deck.online.page.dart';

class ViewDecksOnlinePage extends StatelessWidget {
  const ViewDecksOnlinePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller at the page level
    return ChangeNotifierProvider(
      create: (_) => ViewDecksOnlineController()..loadPublicDecks(),
      child: const _ViewDecksOnlineView(),
    );
  }
}

class _ViewDecksOnlineView extends HookWidget {
  const _ViewDecksOnlineView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ViewDecksOnlineController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Browse Decks')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ListingStatesWrapper<Deck>.wrap(
          isLoading: controller.isLoading,
          exception: controller.error,
          items: controller.decks,
          emptyState: const EmptyState(
            icon: Icons.public,
            title: 'No public decks yet',
            message: 'Published community decks will appear here.',
          ),
          onRetry: controller.loadPublicDecks,
          skeletonTile: DeckListingTile(deck: _skeletonDeck),
          spacing: AppSpacing.xl,
          runSpacing: AppSpacing.xl,
          itemBuilder: (context, _, deck) {
            return DeckListingTile(
              deck: deck,
              onPressed: () => showViewDeckOnlineSheet(context, deck),
            );
          },
        ),
      ),
    );
  }
}

final Deck _skeletonDeck = Deck(
  id: 'loading',
  userId: 'loading',
  title: 'Loading deck',
  shortDescription: 'Loading deck description',
  visibilityState: VisibilityState.public,
  isPublished: true,
  cardCount: 0,
  createdAt: DateTime(2024),
  updatedAt: DateTime(2024),
);
