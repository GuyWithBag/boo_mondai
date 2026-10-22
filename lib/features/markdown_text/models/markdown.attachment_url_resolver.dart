import 'dart:async';

typedef MarkdownAttachmentUrlResolver = FutureOr<String?> Function(Uri uri);
