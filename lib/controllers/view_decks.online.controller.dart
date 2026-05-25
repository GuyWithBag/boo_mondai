// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/view_decks.online.controller.dart
// PURPOSE: State and data fetching for the Online Deck Browser
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/services/services.barrel.dart';

class ViewDecksOnlineController extends Controller {
  final DecksRemoteDB _deckRemoteDB = DecksRemoteDB();
  final DeckDownloadsOnlineService _deckDownloadsService =
      DeckDownloadsOnlineService();

  List<Deck> decks = [];
  List<Tag> availableTags = [];
  String? downloadingDeckId;

  bool isDownloadingDeck(String deckId) => downloadingDeckId == deckId;

  Future<void> loadPublicDecks() async {
    setLoading(true);
    try {
      final publicDecks = await _deckRemoteDB.selectManyPublic();
      decks = ViewDecksService.sortDecks(publicDecks);
      availableTags = ViewDecksService.availableTags(decks);
    } catch (e) {
      setError(e is Exception ? e : Exception(e.toString()));
    } finally {
      setLoading(false);
    }
  }

  Future<Deck?> downloadDeck(Deck deck) async {
    downloadingDeckId = deck.id;
    error = null;
    notifyListeners();

    try {
      return await _deckDownloadsService.downloadDeck(deck);
    } catch (e) {
      setError(e is Exception ? e : Exception(e.toString()));
      return null;
    } finally {
      downloadingDeckId = null;
      notifyListeners();
    }
  }
}
