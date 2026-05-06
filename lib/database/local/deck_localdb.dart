// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/deck_repository.dart
// PURPOSE: Hive CRUD for Deck — source of truth for My Decks
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';

class DeckLocalDB extends HiveLocalDB<Deck> {
  @override
  String get boxName => 'deck_box';

  @override
  String getId(Deck item) => item.id;

  List<Deck> getByCurrentUser() {
    return getAll()
        .where((d) => d.userId == LocalDB.profile.getOrCreate().userId)
        .toList();
  }

  List<Deck> getByUserId(String userId) =>
      box.values.where((d) => d.userId == userId).toList();
}
