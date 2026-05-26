// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/remote/card_template_tag_remote_db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show SupabaseRemoteDB, CardTemplateTag, CardTemplateTagMapper;

class CardTemplateTagsRemoteDB extends SupabaseRemoteDB<CardTemplateTag> {
  @override
  String get tableName => 'card_template_tags';

  @override
  CardTemplateTag Function(Map<String, dynamic>) get fromMap =>
      CardTemplateTagMapper.fromMap;

  @override
  Map<String, dynamic> toMap(CardTemplateTag item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(CardTemplateTag item) => {
    'template_id': item.templateId,
    'tag_id': item.tagId,
  };

  @override
  String get upsertConflictTarget => 'template_id,tag_id';

  // Custom delete for composite keys
  Future<void> deleteComposite({
    required String templateId,
    required String tagId,
  }) => deleteWhere({'template_id': templateId, 'tag_id': tagId});
}
