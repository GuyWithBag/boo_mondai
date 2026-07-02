import 'dart:io';
import 'dart:typed_data';

import 'package:boo_mondai/features/card_attachments/helpers/attachment_label.helper.dart';
import 'package:boo_mondai/features/card_attachments/helpers/mime.helper.dart';
import 'package:boo_mondai/features/card_attachments/media_storage.service.dart';
import 'package:boo_mondai/features/card_attachments/models/card_media_attachment.dto.dart';
import 'package:boo_mondai/lib.barrel.dart' show uuid;
import 'package:file_picker/file_picker.dart';

class CardAttachmentService {
  const CardAttachmentService._();

  static String markdownImageReference(CardAttachment attachment) {
    return '![${attachment.altText ?? attachment.label}](attachment:${attachment.id})';
  }

  static Future<CardMediaAttachment> createLocalImageAttachment({
    required String templateId,
    required PlatformFile file,
    required List<CardAttachment> existingAttachments,
  }) async {
    final attachmentId = uuid.v7();
    final mimeType = MimeHelper.mimeTypeFromFileName(file.name);
    final bytes = file.bytes ?? await _readBytesFromPath(file.path);
    final localPath = await MediaStorageService.saveMediaLocally(
      attachmentId: attachmentId,
      bytes: bytes,
      mimeType: mimeType,
    );
    final existingLabels = existingAttachments
        .map((attachment) => attachment.label)
        .toList(growable: false);
    final label = _labelFromFileName(file.name, existingLabels);

    return CardMediaAttachment(
      id: attachmentId,
      templateId: templateId,
      type: AttachmentType.image,
      label: label,
      storagePath: 'local/$attachmentId',
      localPath: localPath,
      mimeType: mimeType,
      altText: label,
      createdAt: DateTime.now(),
    );
  }

  static Future<Uint8List> _readBytesFromPath(String? path) async {
    if (path == null) {
      throw StateError('Selected file has no readable bytes or local path.');
    }
    return File(path).readAsBytes();
  }

  static String _labelFromFileName(
    String fileName,
    List<String> existingLabels,
  ) {
    final withoutExtension = fileName.contains('.')
        ? fileName.substring(0, fileName.lastIndexOf('.'))
        : fileName;
    final sanitized = AttachmentLabelHelper.sanitizeLabel(withoutExtension);
    final fallback = AttachmentLabelHelper.generateFallbackLabel(
      existingLabels,
    );
    final baseLabel = sanitized.isEmpty ? fallback : sanitized;

    if (AttachmentLabelHelper.validateAttachmentLabel(
          baseLabel,
          existingLabels,
        ) ==
        null) {
      return baseLabel;
    }

    return fallback;
  }
}
