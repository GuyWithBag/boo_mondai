enum StoredMediaKind { image, audio, video, unknown }

abstract final class MediaHelper {
  static const imageExtensions = <String>[
    'jpg',
    'jpeg',
    'png',
    'webp',
    'gif',
    'bmp',
  ];

  static const audioExtensions = <String>[
    'mp3',
    'm4a',
    'aac',
    'wav',
    'ogg',
    'opus',
  ];

  static const videoExtensions = <String>['mp4', 'm4v', 'mov', 'webm'];

  static const supportedExtensions = <String>[
    ...imageExtensions,
    ...audioExtensions,
    ...videoExtensions,
  ];

  static String extensionFromMimeType(String? mimeType) {
    return switch (_normalizedMimeType(mimeType)) {
      'image/jpeg' => 'jpg',
      'image/png' => 'png',
      'image/webp' => 'webp',
      'image/gif' => 'gif',
      'image/bmp' => 'bmp',
      'audio/mpeg' => 'mp3',
      'audio/mp4' => 'm4a',
      'audio/aac' => 'aac',
      'audio/wav' || 'audio/x-wav' => 'wav',
      'audio/ogg' => 'ogg',
      'audio/opus' => 'opus',
      'video/mp4' => 'mp4',
      'video/x-m4v' => 'm4v',
      'video/quicktime' => 'mov',
      'video/webm' => 'webm',
      _ => 'bin',
    };
  }

  static String? mimeTypeFromExtension(String? extension) {
    return switch (_normalizedExtension(extension)) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'webp' => 'image/webp',
      'gif' => 'image/gif',
      'bmp' => 'image/bmp',
      'mp3' => 'audio/mpeg',
      'm4a' => 'audio/mp4',
      'aac' => 'audio/aac',
      'wav' => 'audio/wav',
      'ogg' => 'audio/ogg',
      'opus' => 'audio/opus',
      'mp4' => 'video/mp4',
      'm4v' => 'video/x-m4v',
      'mov' => 'video/quicktime',
      'webm' => 'video/webm',
      _ => null,
    };
  }

  static StoredMediaKind kindFromMimeType(String? mimeType) {
    final normalized = _normalizedMimeType(mimeType);
    if (normalized == null) return StoredMediaKind.unknown;
    if (normalized.startsWith('image/')) return StoredMediaKind.image;
    if (normalized.startsWith('audio/')) return StoredMediaKind.audio;
    if (normalized.startsWith('video/')) return StoredMediaKind.video;
    return StoredMediaKind.unknown;
  }

  static StoredMediaKind kindFromExtension(String? extension) {
    return kindFromMimeType(mimeTypeFromExtension(extension));
  }

  static StoredMediaKind kindFromSource(String source) {
    final uri = Uri.tryParse(source.trim());
    final path = uri?.path.trim().isNotEmpty == true ? uri!.path : source;
    final extension = path.contains('.') ? path.split('.').last : null;
    return kindFromExtension(extension);
  }

  static bool isImageMimeType(String? mimeType) =>
      kindFromMimeType(mimeType) == StoredMediaKind.image;

  static bool isAudioMimeType(String? mimeType) =>
      kindFromMimeType(mimeType) == StoredMediaKind.audio;

  static bool isVideoMimeType(String? mimeType) =>
      kindFromMimeType(mimeType) == StoredMediaKind.video;

  static String? _normalizedMimeType(String? mimeType) {
    final value = mimeType?.split(';').first.trim().toLowerCase();
    return value == null || value.isEmpty ? null : value;
  }

  static String? _normalizedExtension(String? extension) {
    final value = extension?.trim().toLowerCase();
    if (value == null || value.isEmpty) return null;
    return value.startsWith('.') ? value.substring(1) : value;
  }
}
