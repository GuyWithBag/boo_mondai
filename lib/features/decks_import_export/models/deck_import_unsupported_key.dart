enum DeckImportUnsupportedKeyReason { generated, joined, unsupported }

final class DeckImportUnsupportedKey {
  const DeckImportUnsupportedKey({
    required this.path,
    required this.key,
    required this.reason,
  });

  final String path;
  final String key;
  final DeckImportUnsupportedKeyReason reason;
}
