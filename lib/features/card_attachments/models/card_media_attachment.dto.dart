import 'package:dart_mappable/dart_mappable.dart';

part 'card_attachment.dto.dart';
part 'card_link_attachment.dto.dart';
part 'card_media_attachment.dto.mapper.dart';

@MappableEnum()
enum AttachmentType { image, audio }

@MappableClass(discriminatorValue: 'media')
class CardMediaAttachment extends CardAttachment
    with CardMediaAttachmentMappable {
  @override
  final String id;
  @override
  final String templateId;
  @override
  final AttachmentType type;
  @override
  final String label;
  final String storagePath;
  final String? publicUrl;
  final String? localPath;
  final String mimeType;
  @override
  final String? altText;
  @override
  final DateTime createdAt;

  const CardMediaAttachment({
    required this.id,
    required this.templateId,
    required this.type,
    required this.label,
    required this.storagePath,
    this.publicUrl,
    this.localPath,
    required this.mimeType,
    this.altText,
    required this.createdAt,
  });
}
