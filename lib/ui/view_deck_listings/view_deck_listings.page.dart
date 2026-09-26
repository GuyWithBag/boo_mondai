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
        Content,
        ContentType,
        Deck,
        DeckListing,
        DeckListingTile,
        DeckListingTileController,
        DeckWithListingContent,
        FilteredSearchBar,
        FilteredSearchBarController,
        ListingStatesWrapper,
        Pages,
        Profile,
        Scaffold,
        StatusLayoutState,
        ViewDeckListingsController,
        showViewDeckListingSingleSheet;
import 'package:boo_mondai/ui/view_deck_listing_single/controllers/controllers.barrel.dart';
import 'package:boo_mondai/ui/view_deck_listings/view_deck_listings.search.dart';
import 'package:flutter/material.dart'
    show BuildContext, Widget, StatelessWidget, Icons, Center;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewDeckListingsPage extends StatelessWidget {
  const ViewDeckListingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        final controller = ViewDeckListingsController();
        controller.loadPublicDecks();
        return controller;
      },
      dispose: (_, controller) => controller.dispose(),
      child: const _ViewDeckListingsView(),
    );
  }
}

class _ViewDeckListingsView extends SignalHookWidget {
  const _ViewDeckListingsView();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ViewDeckListingsController>();
    final decks = controller.decks.value;
    final isLoading = controller.isLoading.value;
    final error = controller.error.value;
    final searchController = useMemoized(
      () => FilteredSearchBarController<DeckWithListingContent>(
        tokenShapes: ViewDeckListingsSearch.tokenShapes,
        searchTextLabel: ViewDeckListingsSearch.searchTextLabel,
        itemFilter: ViewDeckListingsSearch.itemFilter,
        sorter: ViewDeckListingsSearch.sorter,
        items: decks,
      ),
      const [],
    );

    useEffect(() {
      searchController.setItems(decks);
      return null;
    }, [decks, searchController]);

    useEffect(() => searchController.dispose, [searchController]);

    final visibleDecks = searchController.results.value;
    final hasSearchQuery = searchController.hasText.value;
    final tokens = context.themeTokens<AppTokens>();
    final searchBar = FilteredSearchBar<DeckWithListingContent>(
      controller: searchController,
      placeholder: 'Search public decks',
      resultLabelBuilder: (entry) => entry.deck.title,
      onResultSelected: (entry) => showViewDeckListingSingleSheet(
        context: context,
        controller: _previewController(entry),
      ),
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
      body: ListingStatesWrapper<DeckWithListingContent>.list(
        isLoading: isLoading,
        exception: error,
        items: visibleDecks,
        emptyState: hasSearchQuery
            ? const StatusLayoutState(
                icon: Icons.search_off,
                title: 'No decks found',
                message: 'Try a different query or remove filters.',
              )
            : const StatusLayoutState(
                icon: Icons.public,
                title: 'No public decks yet',
                message: 'Published community decks will appear here.',
              ),
        onRetry: controller.load,
        useParentScroll: true,
        skeletonTile: Center(child: _deckListingTile(_dummyEntry())),
        separatorHeight: tokens.spaceLayoutGapMd,
        itemBuilder: (context, _, entry) {
          return _deckListingTile(
            entry,
            onPressed: () => showViewDeckListingSingleSheet(
              context: context,
              controller: _previewController(entry),
            ),
          );
        },
      ),
    );
  }
}

DeckListingTile _deckListingTile(
  DeckWithListingContent entry, {
  void Function()? onPressed,
}) {
  return DeckListingTile(
    controller: DeckListingTileController(
      deck: entry.deck,
      listing: entry.deckListing,
      content: entry.deckListingContent,
      profile: entry.profile,
      sourceProfile: entry.sourceProfile ?? entry.profile,
    ),
    onPressed: onPressed,
  );
}

ViewDeckListingSinglePreviewController _previewController(
  DeckWithListingContent entry,
) {
  return ViewDeckListingSinglePreviewController(
    deck: signal(entry.deck),
    listing: signal(entry.deckListing),
    content: signal(entry.deckListingContent),
    profile: signal(entry.profile),
    sourceProfile: signal(entry.sourceProfile ?? entry.profile),
  );
}

DeckWithListingContent _dummyEntry() {
  final now = DateTime.now();
  final profile = Profile(
    displayName: '',
    id: '',
    createdAt: now,
    updatedAt: now,
    userId: '',
    username: '',
  );
  return (
    deck: Deck.createDummy(title: 'Loading listing'),
    deckListing: const DeckListing(deckId: '', contentId: ''),
    deckListingContent: Content(
      id: '',
      profileId: '',
      type: ContentType.deck,
      createdAt: now,
      updatedAt: now,
    ),
    profile: profile,
    sourceProfile: profile,
  );
}
