import 'package:boo_mondai/features/card_attachments/models/card_media_attachment.dto.dart';
import 'package:boo_mondai/lib.barrel.dart' show SupabaseRemoteDB;

class CardMediaAttachmentsRemoteDB extends SupabaseRemoteDB<CardAttachment> {
  @override
  String get tableName => 'card_template_attachments';

  @override
  CardAttachment Function(Map<String, dynamic>) get fromMap =>
      _attachmentFromMap;

  @override
  Map<String, dynamic> toMap(CardAttachment item) => switch (item) {
    CardMediaAttachment attachment => {
      'attachment_source': 'media',
      'id': attachment.id,
      'template_id': attachment.templateId,
      'type': attachment.type.name,
      'label': attachment.label,
      'storage_path': attachment.storagePath,
      'public_url': attachment.publicUrl,
      'mime_type': attachment.mimeType,
      'alt_text': attachment.altText,
      'created_at': attachment.createdAt.toIso8601String(),
    },
    CardLinkAttachment attachment => {
      'attachment_source': 'link',
      'id': attachment.id,
      'template_id': attachment.templateId,
      'type': attachment.type.name,
      'label': attachment.label,
      'url': attachment.url,
      'alt_text': attachment.altText,
      'created_at': attachment.createdAt.toIso8601String(),
    },
  };

  @override
  Map<String, Object?> primaryKeyFromItem(CardAttachment item) => {
    'id': item.id,
  };

  @override
  String get upsertConflictTarget => 'id';

  Future<List<CardAttachment>> selectByTemplateId(String templateId) =>
      selectMany(filters: {'template_id': templateId}, orderBy: 'created_at');

  Future<void> deleteByTemplateId(String templateId) =>
      deleteWhere({'template_id': templateId});

  CardAttachment _attachmentFromMap(Map<String, dynamic> map) {
    final values = Map<String, dynamic>.from(map);
    values['attachment_source'] ??= values['url'] == null ? 'media' : 'link';
    values['type'] ??= values.remove('kind');
    values['label'] ??= 'new-file-1';
    return CardAttachmentMapper.fromMap(values);
  }
}
