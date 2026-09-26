// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/view_decks.online.controller.dart
// PURPOSE: State and data fetching for the Online Deck Browser
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show DeckDownloadsService, DeckWithListingContent, Services, Tag, RemoteDB;
import 'package:boo_mondai/ui/view_deck_listings/view_deck_listings.search.dart';
import 'package:signals/signals_flutter.dart';

// ToDo: Need review
class ViewDeckListingsController {
  final DeckDownloadsService deckDownloadsService = Services.deckDownloads;

  final decks = signal<List<DeckWithListingContent>>(const []);
  final availableTags = signal<List<Tag>>(const []);

  // final downloadingDeckId = signal<String?>(null);

  final isLoading = signal(false);
  final error = signal<Exception?>(null);

  Future<void> loadPublicDecks() => load();

  Future<void> load() async {
    isLoading.value = true;
    error.value = null;
    try {
      final publicDecks = await RemoteDB.deck.selectManyPublic();
      final publicListings = <DeckWithListingContent>[];

      for (final deck in publicDecks) {
        final listing = await RemoteDB.deck.selectWithListingContentById(
          deck.id,
        );
        if (listing != null) publicListings.add(listing);
      }

      decks.value = ViewDeckListingsSearch.sorter(publicListings, null);
      availableTags.value = ViewDeckListingsSearch.availableTags(decks.value);
    } catch (e) {
      error.value = e is Exception ? e : Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void dispose() {
    error.dispose();
    isLoading.dispose();
    availableTags.dispose();
    decks.dispose();
  }

  // Future<Deck?> downloadDeck(Deck deck) async {
  //   downloadingDeckId.value = deck.id;
  //   error.value = null;

  //   try {
  //     final result = await deckDownloadsService.downloadDeck(deck);
  //     return result.value.deck;
  //   } catch (e) {
  //     error.value = e is Exception ? e : Exception(e.toString());
  //     return null;
  //   } finally {
  //     downloadingDeckId.value = null;
  //   }
  // }
}
