const _forbiddenAttachmentLabelCharacters = {
  '/',
  r'\',
  ':',
  '*',
  '?',
  '"',
  '<',
  '>',
  '|',
};

class AttachmentLabelHelper {
  const AttachmentLabelHelper._();

  // Returns an error string if invalid, null if valid.
  static String? validateAttachmentLabel(
    String label,
    List<String> existingLabels,
  ) {
    final trimmed = label.trim();
    if (trimmed.isEmpty) {
      return 'Label is required.';
    }

    if (trimmed.runes.any((rune) {
      return _forbiddenAttachmentLabelCharacters.contains(
        String.fromCharCode(rune),
      );
    })) {
      return r'Label cannot contain / \ : * ? " < > |.';
    }

    final normalized = trimmed.toLowerCase();
    final existing = existingLabels.map((value) => value.trim().toLowerCase());
    if (existing.contains(normalized)) {
      return 'Label must be unique within the deck.';
    }

    return null;
  }

  // Returns next available fallback label.
  static String generateFallbackLabel(List<String> existingLabels) {
    final existing = existingLabels
        .map((value) => value.trim().toLowerCase())
        .toSet();
    var index = 1;
    while (existing.contains('new-file-$index')) {
      index++;
    }
    return 'new-file-$index';
  }

  // Strips forbidden characters and trims.
  static String sanitizeLabel(String raw) {
    final buffer = StringBuffer();
    for (final rune in raw.runes) {
      final character = String.fromCharCode(rune);
      if (!_forbiddenAttachmentLabelCharacters.contains(character)) {
        buffer.write(character);
      }
    }
    return buffer.toString().trim();
  }
}
