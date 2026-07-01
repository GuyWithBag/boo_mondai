import 'package:boo_mondai/features/card_attachments/models/card_media_attachment.dto.dart';

class AttachmentUriHelper {
  const AttachmentUriHelper._();

  static String? resolveAttachmentUri(CardAttachment attachment) {
    return switch (attachment) {
      CardMediaAttachment a => a.localPath ?? a.publicUrl,
      CardLinkAttachment a => a.url,
    };
  }
}
