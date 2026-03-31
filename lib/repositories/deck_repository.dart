// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/deck_repository.dart
// PURPOSE: Hive CRUD for Deck — source of truth for My Decks
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:hive_ce/hive.dart';
import '../models/deck.dart';

class DeckRepository {
  static const String boxName = 'deck_box';

  Box<Deck> get _box => Hive.box<Deck>(boxName);

  List<Deck> getAll() => _box.values.toList();

  Deck? getById(String id) => _box.get(id);

  List<Deck> getByCreatorId(String creatorId) =>
      _box.values.where((d) => d.creatorId == creatorId).toList();

  Future<void> save(Deck deck) => _box.put(deck.id, deck);

  Future<void> saveAll(List<Deck> decks) async {
    final map = {for (final d in decks) d.id: d};
    await _box.putAll(map);
  }

  Future<void> delete(String id) => _box.delete(id);

  Future<void> deleteAll(List<String> ids) => _box.deleteAll(ids);

  Future<void> clear() => _box.clear();
}
