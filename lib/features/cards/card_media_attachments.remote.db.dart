import 'package:boo_mondai/lib.barrel.dart'
    show CardMediaAttachment, CardMediaAttachmentMapper, SupabaseRemoteDB;

class CardMediaAttachmentsRemoteDB
    extends SupabaseRemoteDB<CardMediaAttachment> {
  @override
  String get tableName => 'card_template_attachments';

  @override
  CardMediaAttachment Function(Map<String, dynamic>) get fromMap =>
      CardMediaAttachmentMapper.fromMap;

  @override
  Map<String, dynamic> toMap(CardMediaAttachment item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(CardMediaAttachment item) => {
    'id': item.id,
  };

  @override
  String get upsertConflictTarget => 'id';

  Future<List<CardMediaAttachment>> selectByTemplateId(String templateId) =>
      selectMany(filters: {'template_id': templateId}, orderBy: 'created_at');

  Future<void> deleteByTemplateId(String templateId) =>
      deleteWhere({'template_id': templateId});
}
