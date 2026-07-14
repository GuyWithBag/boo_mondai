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

  List<CardTemplateTag> getTagsForTemplates(Set<String> templateIds) =>
      guardSync(
        () => box.values
            .where((item) => templateIds.contains(item.templateId))
            .toList(),
        action: 'getTagsForTemplates(${templateIds.length} templateIds)',
      );

  Future<void> deleteByTemplateIds(Set<String> templateIds) => guard(() async {
    final keys = box.values
        .where((item) => templateIds.contains(item.templateId))
        .map(primaryKeyFromItem)
        .toList();
    await box.deleteAll(keys.map(encodePrimaryKey));
  }, action: 'deleteByTemplateIds(${templateIds.length} templateIds)');

  bool isTagReferenced(String tagId) => guardSync(
    () => box.values.any((item) => item.tagId == tagId),
    action: 'isTagReferenced($tagId)',
  );
}
