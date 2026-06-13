// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/view_decks.online.controller.dart
// PURPOSE: State and data fetching for the Online Deck Browser
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/features/change_review/change_review_controller.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        Controller,
        DecksRemoteDB,
        DeckDownloadsService,
        Deck,
        DeckSearchResults,
        Tag;

class ViewDecksOnlineController extends Controller {
  final DecksRemoteDB _deckRemoteDB = DecksRemoteDB();
  final DeckDownloadsService _deckDownloadsService = DeckDownloadsService();

  List<Deck> decks = [];
  List<Tag> availableTags = [];
  String? downloadingDeckId;

  bool isDownloadingDeck(String deckId) => downloadingDeckId == deckId;

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
    required ChangeReviewController controller,
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
