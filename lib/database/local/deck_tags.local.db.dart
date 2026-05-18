// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/local/deck_tag_local_db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
import 'package:boo_mondai/models/dtos/deck_tag.dto.dart';
import 'package:boo_mondai/database/local/hive.local.db.dart';

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
}
