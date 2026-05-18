// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/local/card_template_tag_local_db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
import 'package:boo_mondai/models/dtos/card_template_tag.dto.dart';
import 'package:boo_mondai/database/local/hive.local.db.dart';

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
