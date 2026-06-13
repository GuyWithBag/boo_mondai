// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/my_decks_page.dart
// PURPOSE: Lists user's decks with search, swipe-to-delete, and FAB to create new
// PROVIDERS: ViewDecksLocalController
// HOOKS: useEffect, useScrollController, useTextEditingController
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AuthController,
        CreateDeckTile,
        Deck,
        DeckSearchFilter,
        DeckTile,
        DeckTileState,
        EmptyState,
        FilteredSearchBar,
        ListingStatesWrapper,
        SyncButton,
        ViewDecksLocalController,
        showCreateDeckLocalSheet,
        useFilteredSearchBarController,
        Button;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ViewDecksLocalPage extends HookWidget {
  const ViewDecksLocalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ViewDecksLocalController>();
    final auth = context.watch<AuthController>();
    // final scrollController = useScrollController();

    useEffect(() {
      controller.loadOnNextFrame();
      return null;
    }, const []);

    useEffect(() {
      controller.showSyncErrorIfPresent(context);
      return null;
    }, [controller.syncError]);

    final searchController =
        useFilteredSearchBarController<Deck, DeckSearchFilter>(
          filterCodec: ViewDecksLocalController.deckSearchFilterCodec,
          searchResults: ViewDecksLocalController.deckSearchResults,
          items: controller.decks,
        );
    final visibleDecks = searchController.results;
    final hasSearchQuery = searchController.text.trim().isNotEmpty;

    final searchBar = FilteredSearchBar<Deck, DeckSearchFilter>(
      controller: searchController,
      filterCodec: ViewDecksLocalController.deckSearchFilterCodec,
      searchResults: ViewDecksLocalController.deckSearchResults,
      items: controller.decks,
      placeholder: 'Search decks',
      onResultSelected: (deck) => controller.goToDeck(context, deck),
      onSubmitted: (_) => controller.submitSearch(context, visibleDecks),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Decks'),
        actions: [
          SyncButton(
            isSyncing: controller.isSyncing,
            isAuthenticated: auth.service.isAuthenticatedRemote,
            onSync: () => controller.sync(),
          ),
          Button.icon(
            icon: Icons.layers_rounded,
            onPressed: () => context.push('/view-cards'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(100.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              searchBar,
              const SizedBox(height: 24),
              _DeckListBody(
                error: controller.error,
                isLoading: controller.isLoading,
                onRetry: controller.load,
                onDeleteDeck: controller.deleteDeck,
                onPressed: controller.goToDeck,
                decks: visibleDecks,
                hasSearchQuery: hasSearchQuery,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── _DeckListBody ─────────────────────────────────────────────────────────────

class _DeckListBody extends StatelessWidget {
  const _DeckListBody({
    required this.isLoading,
    required this.error,
    required this.decks,
    required this.onRetry,
    required this.onDeleteDeck,
    required this.onPressed,
    required this.hasSearchQuery,
  });

  final bool isLoading;
  final Exception? error;
  final List<Deck> decks;
  final VoidCallback onRetry;
  final Function(BuildContext context, Deck deck) onPressed;
  final void Function(String id) onDeleteDeck;
  final bool hasSearchQuery;

  @override
  Widget build(BuildContext context) {
    return ListingStatesWrapper<Deck>.wrap(
      isLoading: isLoading,
      exception: error,
      items: decks,
      onRetry: onRetry,
      skeletonTile: DeckTile(deck: null),
      emptyState: hasSearchQuery
          ? const EmptyState(
              icon: Icons.search_off,
              title: 'No decks found',
              message: 'Try another search or remove filters',
            )
          : EmptyState(
              icon: Icons.layers,
              title: 'No decks yet',
              message: 'Create your first deck to get started',
              action: ElevatedButton(
                child: Text('Create Deck'),
                onPressed: () => showCreateDeckLocalSheet(context),
              ),
            ),
      spacing: 100,
      leadingItem: CreateDeckTile(
        onPressed: () => showCreateDeckLocalSheet(context),
      ),
      itemBuilder: (_, _, deck) {
        return DeckTile(
          deck: deck,
          state: DeckTileState.defaultView,
          onPressed: () {
            onPressed(context, deck);
          },
        );
      },
    );
  }
}
