import 'package:dart_mappable/dart_mappable.dart';

part 'card_media_attachment.dto.mapper.dart';

@MappableEnum()
enum CardMediaKind { image, audio }

@MappableClass()
class CardMediaAttachment with CardMediaAttachmentMappable {
  final String id;
  final String templateId;
  final CardMediaKind kind;
  final String storagePath;
  final String? publicUrl;
  final String? mimeType;
  final String? altText;
  final DateTime createdAt;

  const CardMediaAttachment({
    required this.id,
    required this.templateId,
    required this.kind,
    required this.storagePath,
    this.publicUrl,
    this.mimeType,
    this.altText,
    required this.createdAt,
  });
}
