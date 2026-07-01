class MimeHelper {
  const MimeHelper._();

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
