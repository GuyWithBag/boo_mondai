// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/view_decks_online_page.dart
// PURPOSE: Browse all public user-created decks with tag filters
// HOOKS: useEffect, useTextEditingController, useState
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        Button,
        Deck,
        DeckListingTile,
        DeckSearchFilter,
        DeckSearchFilterCodec,
        DeckSearchResults,
        EmptyState,
        FilteredSearchBar,
        ListingStatesWrapper,
        Pages,
        Scaffold,
        ViewDeckListingsController,
        VisibilityState,
        showViewDeckListingSingleSheet,
        useFilteredSearchBarController;
import 'package:flutter/material.dart'
    show BuildContext, Widget, StatelessWidget, Icons, Center;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewDeckListingsPage extends StatelessWidget {
  const ViewDeckListingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller at the page level
    return ChangeNotifierProvider(
      create: (_) => ViewDeckListingsController()..loadPublicDecks(),
      child: const _ViewDeckListingsView(),
    );
  }
}

class _ViewDeckListingsView extends HookWidget {
  const _ViewDeckListingsView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ViewDeckListingsController>();
    final searchController =
        useFilteredSearchBarController<Deck, DeckSearchFilter>(
          filterCodec: const DeckSearchFilterCodec(),
          searchResults: const DeckSearchResults(),
          items: controller.decks,
        );
    final visibleDecks = searchController.results;
    final hasSearchQuery = searchController.text.trim().isNotEmpty;
    final tokens = context.themeTokens<AppTokens>();
    final searchBar = FilteredSearchBar<Deck, DeckSearchFilter>(
      controller: searchController,
      filterCodec: const DeckSearchFilterCodec(),
      searchResults: const DeckSearchResults(),
      items: controller.decks,
      placeholder: 'Search public decks',
      resultLabelBuilder: (deck) => deck.title,
    );

    return Scaffold(
      appBar: AppBar(
        title: 'Browse Decks',
        header: searchBar,
        actions: [
          Button.icon(
            tokens: tokens,
            icon: Pages.downloads.icon,
            onPressed: () => context.push(Pages.downloads.url),
          ),
        ],
      ),
      scrollable: true,
      body: ListingStatesWrapper<Deck>.list(
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
        useParentScroll: true,
        skeletonTile: Center(child: DeckListingTile(deck: _skeletonDeck)),
        separatorHeight: tokens.spaceLayoutGapMd,
        itemBuilder: (context, _, deck) {
          return DeckListingTile(
            deck: deck,
            onPressed: () => showViewDeckListingSingleSheet(context, deck),
          );
        },
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
