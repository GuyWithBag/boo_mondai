// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/view_decks.online.controller.dart
// PURPOSE: State and data fetching for the Online Deck Browser
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/features/change_tracker/change_tracker.controller.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        Controller,
        DecksRemoteDB,
        DeckDownloadsService,
        Deck,
        DeckSearchResults,
        Tag;

class ViewDeckListingsController extends Controller {
  final DecksRemoteDB _deckRemoteDB = DecksRemoteDB();
  final DeckDownloadsService _deckDownloadsService = DeckDownloadsService();

  List<Deck> decks = [];
  List<Tag> availableTags = [];
  String? downloadingDeckId;

  bool isDownloadingDeck(String deckId) => downloadingDeckId == deckId;

  void replaceDeck(Deck deck) {
    decks = [
      for (final current in decks)
        if (current.id == deck.id) deck else current,
    ];

    if (!decks.any((current) => current.id == deck.id)) {
      decks = [deck, ...decks];
    }

    const deckSearchResults = DeckSearchResults();
    availableTags = deckSearchResults.availableTags(decks);
    notifyListeners();
  }

  Future<void> loadPublicDecks() async {
    setLoading(true);
    try {
      final publicDecks = await _deckRemoteDB.selectManyPublic();
      const deckSearchResults = DeckSearchResults();
      decks = deckSearchResults.sortDecks(publicDecks);
      availableTags = deckSearchResults.availableTags(decks);
    } catch (e) {
      setError(e is Exception ? e : Exception(e.toString()));
    } finally {
      setLoading(false);
    }
  }

  Future<Deck?> downloadDeck(
    Deck deck, {
    required ChangeTrackerController controller,
  }) async {
    downloadingDeckId = deck.id;
    error = null;
    notifyListeners();

    try {
      final result = await _deckDownloadsService.downloadDeck(deck, controller);
      return result.value.deck;
    } catch (e) {
      setError(e is Exception ? e : Exception(e.toString()));
      return null;
    } finally {
      downloadingDeckId = null;
      notifyListeners();
    }
  }
}
