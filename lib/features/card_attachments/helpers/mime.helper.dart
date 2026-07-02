class MimeHelper {
  const MimeHelper._();

  static String mimeTypeFromFileName(String fileName) {
    final extension = fileName.contains('.')
        ? fileName.split('.').last.toLowerCase()
        : '';

    return switch (extension) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      'webp' => 'image/webp',
      'mp3' => 'audio/mpeg',
      'ogg' => 'audio/ogg',
      'wav' => 'audio/wav',
      _ => 'application/octet-stream',
    };
  }

  static String extensionFromMimeType(String mimeType) {
    return switch (mimeType.toLowerCase().split(';').first.trim()) {
      'image/jpeg' => 'jpg',
      'image/png' => 'png',
      'image/webp' => 'webp',
      'audio/mpeg' => 'mp3',
      'audio/ogg' => 'ogg',
      'audio/wav' => 'wav',
      _ => 'bin',
    };
  }
}
