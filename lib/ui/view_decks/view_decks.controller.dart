import 'package:boo_mondai/lib.barrel.dart'
    show
        Deck,
        DecksService,
        DeckWithListingContent,
        LocalDB,
        ViewDeckListingSingleEditorController,
        showViewDeckListingSingleSheet,
        showViewDeckSingleSheet;
import 'package:boo_mondai/ui/view_decks/view_decks.search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:signals/signals_flutter.dart';

class ViewDecksLocalController {
  ViewDecksLocalController() {
    deckListenable = LocalDB.deck.box.listenable();
    deckListingListenable = LocalDB.deckListing.box.listenable();
    deckListenable.addListener(load);
    deckListingListenable.addListener(load);
  }

  late final Listenable deckListenable;
  late final Listenable deckListingListenable;

  final decks = listSignal<Deck>(const []);
  final listingEntries = listSignal<DeckWithListingContent>(const []);
  final activeScope = signal(ViewDecksSearchScope.decks);
  final isLoading = signal(false);
  final error = signal<Exception?>(null);

  late final scopeOptions = computed(
    () => const [
      ViewDecksScopeOption(value: ViewDecksSearchScope.decks, label: 'Decks'),
      ViewDecksScopeOption(
        value: ViewDecksSearchScope.listings,
        label: 'Listings',
      ),
    ],
  );

  late final isDeckScope = computed(
    () => activeScope.value == ViewDecksSearchScope.decks,
  );

  void loadOnNextFrame() {
    SchedulerBinding.instance.addPostFrameCallback((_) => load());
  }

  void load() {
    isLoading.value = true;
    error.value = null;

    try {
      final loadedDecks = LocalDB.deck.filterDecks();
      decks.value = List.unmodifiable(loadedDecks);
      listingEntries.value = List.unmodifiable(
        _buildListingEntries(loadedDecks),
      );
    } on Exception catch (e) {
      error.value = e;
    } finally {
      isLoading.value = false;
    }
  }

  List<DeckWithListingContent> _buildListingEntries(List<Deck> decks) {
    return [
      for (final deck in decks)
        ?LocalDB.deck.selectWithListingContentByDeck(deck),
    ];
  }

  void setActiveScope(ViewDecksSearchScope value) {
    activeScope.value = value;
  }

  void goToDeck(BuildContext context, Deck deck) {
    showViewDeckSingleSheet(context, deck);
  }

  void goToListing(BuildContext context, DeckWithListingContent entry) {
    showViewDeckListingSingleSheet(
      context: context,
      controller: ViewDeckListingSingleEditorController(
        deck: signal(entry.deck),
        content: signal(entry.deckListingContent),
        listing: signal(entry.deckListing),
        profile: signal(entry.profile),
        sourceProfile: signal(entry.sourceProfile ?? entry.profile),
      ),
    );
  }

  Future<void> createDeck(BuildContext context) async {
    isLoading.value = true;
    error.value = null;
    try {
      final deck = await DecksService.createAndUpsert();

      if (context.mounted) {
        showViewDeckSingleSheet(context, deck);
      }
    } on Exception catch (e) {
      error.value = e;
      isLoading.value = false;
    }
  }

  Future<void> deleteDeck(Deck deck) async {
    isLoading.value = true;
    error.value = null;
    try {
      await DecksService.deleteDeckCascades(deck: deck);
    } on Exception catch (e) {
      error.value = e;
      isLoading.value = false;
    }
  }

  Future<void> deleteDecks(List<Deck> decks) async {
    if (decks.isEmpty) return;

    isLoading.value = true;
    error.value = null;
    try {
      for (final deck in decks) {
        await DecksService.deleteDeckCascades(deck: deck);
      }
    } on Exception catch (e) {
      error.value = e;
      isLoading.value = false;
    }
  }

  void clearError() {
    error.value = null;
  }

  void dispose() {
    deckListenable.removeListener(load);
    deckListingListenable.removeListener(load);

    isDeckScope.dispose();
    scopeOptions.dispose();
    error.dispose();
    isLoading.dispose();
    activeScope.dispose();
    listingEntries.dispose();
    decks.dispose();
  }
}
