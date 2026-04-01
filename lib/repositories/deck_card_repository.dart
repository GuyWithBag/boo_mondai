// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/deck_card_repository.dart
// PURPOSE: Hive CRUD for DeckCard — source of truth for cards belonging to a deck
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:uuid/uuid.dart';

import '../models/deck_card.dart';
import 'hive_repository.dart';

class DeckCardRepository extends HiveRepository<DeckCard> {
  @override
  String get boxName => 'deck_card_box';

  @override
  String getId(DeckCard item) => item.id;

  List<DeckCard> getByDeckId(String deckId) =>
      box.values.where((c) => c.deckId == deckId).toList();

  Future<void> deleteByDeckId(String deckId) async {
    final keys = box.values
        .where((c) => c.deckId == deckId)
        .map((c) => c.id)
        .toList();
    await box.deleteAll(keys);
  }
}
