// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/remote/deck_tag_remote_db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/models/dtos/deck_tag.dto.dart';

class DeckTagsRemoteDB extends SupabaseRemoteDB<DeckTag> {
  @override
  String get tableName => 'deck_tags';

  @override
  DeckTag Function(Map<String, dynamic>) get fromMap => DeckTagMapper.fromMap;

  @override
  Map<String, dynamic> toMap(DeckTag item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(DeckTag item) => {
    'deck_id': item.deckId,
    'tag_id': item.tagId,
  };

  @override
  String get upsertConflictTarget => 'deck_id,tag_id';

  // Custom delete for composite keys
  Future<void> deleteComposite({
    required String deckId,
    required String tagId,
  }) => deleteWhere({'deck_id': deckId, 'tag_id': tagId});
}
