part of 'card_media_attachment.dto.dart';

@MappableClass(discriminatorValue: 'link')
class CardLinkAttachment extends CardAttachment
    with CardLinkAttachmentMappable {
  @override
  final String id;
  @override
  final String templateId;
  @override
  final AttachmentType type;
  @override
  final String label;
  final String url;
  @override
  final String? altText;
  @override
  final DateTime createdAt;

  const CardLinkAttachment({
    required this.id,
    required this.templateId,
    required this.type,
    required this.label,
    required this.url,
    this.altText,
    required this.createdAt,
  });
}
