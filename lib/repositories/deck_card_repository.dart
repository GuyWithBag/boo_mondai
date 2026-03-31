// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/deck_card_repository.dart
// PURPOSE: Hive CRUD for DeckCard — source of truth for cards belonging to a deck
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:hive_ce/hive.dart';
import '../models/deck_card.dart';

class DeckCardRepository {
  static const String boxName = 'deck_card_box';

  Box<DeckCard> get _box => Hive.box<DeckCard>(boxName);

  List<DeckCard> getAll() => _box.values.toList();

  DeckCard? getById(String id) => _box.get(id);

  List<DeckCard> getByDeckId(String deckId) =>
      _box.values.where((c) => c.deckId == deckId).toList();

  Future<void> save(DeckCard card) => _box.put(card.id, card);

  Future<void> saveAll(List<DeckCard> cards) async {
    final map = {for (final c in cards) c.id: c};
    await _box.putAll(map);
  }

  Future<void> delete(String id) => _box.delete(id);

  Future<void> deleteByDeckId(String deckId) async {
    final keys = _box.values
        .where((c) => c.deckId == deckId)
        .map((c) => c.id)
        .toList();
    await _box.deleteAll(keys);
  }

  Future<void> deleteAll(List<String> ids) => _box.deleteAll(ids);

  Future<void> clear() => _box.clear();
}
