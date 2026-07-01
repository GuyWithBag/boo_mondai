part of 'card_media_attachment.dto.dart';

@MappableClass(
  discriminatorKey: 'attachment_source',
  includeSubClasses: [CardMediaAttachment, CardLinkAttachment],
)
sealed class CardAttachment with CardAttachmentMappable {
  String get id;
  String get templateId;
  AttachmentType get type;
  String get label;
  String? get altText;
  DateTime get createdAt;

  const CardAttachment();
}
