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

  List<Deck> decks = [];
  List<Tag> availableTags = [];

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
}
