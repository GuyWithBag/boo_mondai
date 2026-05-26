// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/local/card_template_tag_local_db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart' show HiveLocalDB, CardTemplateTag;

class CardTemplateTagsLocalDB extends HiveLocalDB<CardTemplateTag> {
  @override
  String get boxName => 'card_template_tags';

  @override
  Map<String, Object?> primaryKeyFromItem(CardTemplateTag item) => {
    'template_id': item.templateId,
    'tag_id': item.tagId,
  };

  // Get all tags for a specific template
  List<CardTemplateTag> getTagsForTemplate(String templateId) => guardSync(
    () => box.values.where((item) => item.templateId == templateId).toList(),
    action: 'getTagsForTemplate($templateId)',
  );
}
