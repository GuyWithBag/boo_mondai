// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/repositories/deck_card_repository.dart
// PURPOSE: Hive CRUD for CardTemplate — source of truth for cards belonging to a deck
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart' show CardTemplate, HiveLocalDB;

class CardTemplatesLocalDB extends HiveLocalDB<CardTemplate> {
  @override
  String get boxName => 'card_templates';

  @override
  Map<String, Object?> primaryKeyFromItem(CardTemplate item) => {'id': item.id};

  List<CardTemplate> getByDeckId(String deckId) => guardSync(
    () => box.values.where((c) => c.deckId == deckId).toList(),
    action: 'getByDeckId($deckId)',
  );

  Future<void> deleteByDeckId(String deckId) => guard(() async {
    final keys = box.values
        .where((c) => c.deckId == deckId)
        .map((c) => primaryKeyFromItem(c))
        .toList();
    await box.deleteAll(keys.map(encodePrimaryKey));
  }, action: 'deleteByDeckId($deckId)');
}
