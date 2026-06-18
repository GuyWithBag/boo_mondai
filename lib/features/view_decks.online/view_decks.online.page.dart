// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/view_decks_online_page.dart
// PURPOSE: Browse all public user-created decks with tag filters
// HOOKS: useEffect, useTextEditingController, useState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        ViewDecksOnlineController,
        Deck,
        DeckSearchFilter,
        DeckSearchFilterCodec,
        DeckSearchResults,
        FilteredSearchBar,
        ListingStatesWrapper,
        EmptyState,
        DeckListingTile,
        VisibilityState,
        showViewDeckOnlineSheet,
        useFilteredSearchBarController,
        AppBar,
        PageScaffold,
        AppTokens;
import 'package:flutter/material.dart'
    show
        BuildContext,
        Widget,
        StatelessWidget,
        CrossAxisAlignment,
        Icons,
        Center,
        Column;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

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
    final searchController =
        useFilteredSearchBarController<Deck, DeckSearchFilter>(
          filterCodec: const DeckSearchFilterCodec(),
          searchResults: const DeckSearchResults(),
          items: controller.decks,
        );
    final visibleDecks = searchController.results;
    final hasSearchQuery = searchController.text.trim().isNotEmpty;
    final tokens = context.themeTokens<AppTokens>();
    return PageScaffold(
      appBar: AppBar(title: 'Browse Decks'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilteredSearchBar<Deck, DeckSearchFilter>(
            controller: searchController,
            filterCodec: const DeckSearchFilterCodec(),
            searchResults: const DeckSearchResults(),
            items: controller.decks,
            placeholder: 'Search public decks',
          ),
          ListingStatesWrapper<Deck>.list(
            isLoading: controller.isLoading,
            exception: controller.error,
            items: visibleDecks,
            emptyState: hasSearchQuery
                ? const EmptyState(
                    icon: Icons.search_off,
                    title: 'No decks found',
                    message: 'Try a different query or remove filters.',
                  )
                : const EmptyState(
                    icon: Icons.public,
                    title: 'No public decks yet',
                    message: 'Published community decks will appear here.',
                  ),
            onRetry: controller.loadPublicDecks,
            skeletonTile: Center(child: DeckListingTile(deck: _skeletonDeck)),
            separatorHeight: tokens.spaceLayoutGapMd,
            itemBuilder: (context, _, deck) {
              return Center(
                child: DeckListingTile(
                  deck: deck,
                  onPressed: () => showViewDeckOnlineSheet(context, deck),
                ),
              );
            },
          ),
        ],
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
