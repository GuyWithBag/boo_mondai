// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/controllers/view_decks_online_page_controller.dart
// PURPOSE: State and data fetching for the Online Deck Browser
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';

class ViewDecksOnlinePageController extends Controller {
  final DeckRemoteDB _deckRemoteDB = DeckRemoteDB();

  List<Deck> decks = [];
  List<Tag> availableTags = [];

  Future<void> loadPublicDecks() async {
    setLoading(true);
    try {
      decks = await _deckRemoteDB.selectManyPublic();

      // Extract unique tags from all fetched decks for the filter bar
      final tagMap = <String, Tag>{};
      for (final deck in decks) {
        for (final tag in deck.tags) {
          tagMap[tag.id] = tag;
        }
      }

      availableTags = tagMap.values.toList()
        ..sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      setError(e is Exception ? e : Exception(e.toString()));
    } finally {
      setLoading(false);
    }
  }
}
