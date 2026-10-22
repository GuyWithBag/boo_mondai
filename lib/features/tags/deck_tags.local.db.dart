// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/local/deck_tag_local_db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart' show HiveLocalDB, DeckTag;

class DeckTagsLocalDB extends HiveLocalDB<DeckTag> {
  @override
  String get boxName => 'deck_tags';

  @override
  Map<String, Object?> primaryKeyFromItem(DeckTag item) => {
    'deck_id': item.deckId,
    'tag_id': item.tagId,
  };

  // Get all tags for a specific deck
  List<DeckTag> getTagsForDeck(String deckId) => guardSync(
    () => box.values.where((item) => item.deckId == deckId).toList(),
    action: 'getTagsForDeck($deckId)',
  );

  Future<void> deleteByDeckId(String deckId) => guard(() async {
    final keys = box.values
        .where((item) => item.deckId == deckId)
        .map(primaryKeyFromItem)
        .toList();
    await box.deleteAll(keys.map(encodePrimaryKey));
  }, action: 'deleteByDeckId($deckId)');

  bool isTagReferenced(String tagId) => guardSync(
    () => box.values.any((item) => item.tagId == tagId),
    action: 'isTagReferenced($tagId)',
  );
}
