// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/deck_repository.dart
// PURPOSE: Hive CRUD for Deck — source of truth for My Decks
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart';

import '../models/deck.dart';
import 'hive_repository.dart';

class DeckRepository extends HiveRepository<Deck> {
  @override
  String get boxName => 'deck_box';

  @override
  String getId(Deck item) => item.id;

  List<Deck> getByCurrentUser() {
    return getAll()
        .where(
          (d) => d.authorId == Repositories.userProfile.getAll().first.userId,
        )
        .toList();
  }

  List<Deck> getByAuthorId(String authorId) =>
      box.values.where((d) => d.authorId == authorId).toList();
}
