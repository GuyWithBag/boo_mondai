import 'package:boo_mondai/lib.barrel.dart'
    show BucketSupabaseRemoteDB, StoredMedia, SyncMediaSourceApplier;

typedef SyncMarkdownMediaRemotePathBuilder =
    String Function(StoredMedia storedMedia, int index);

abstract final class SyncMarkdownMediaApplier {
  static final RegExp _markdownMediaPattern = RegExp(
    r'(!?\[[^\]]*\]\()([^)]+)(\))',
  );

  static Future<String> uploadAndRewrite({
    required String markdown,
    required BucketSupabaseRemoteDB bucket,
    required SyncMarkdownMediaRemotePathBuilder remotePath,
    bool upsert = true,
  }) async {
    if (markdown.trim().isEmpty) return markdown;

    final matches = _markdownMediaPattern.allMatches(markdown).toList();
    if (matches.isEmpty) return markdown;

    final replacements = <_MarkdownMediaReplacement>[];

    for (var index = 0; index < matches.length; index++) {
      final match = matches[index];
      final source = match.group(2);
      if (source == null || source.trim().isEmpty) continue;

      var storedMediaIndex = index;
      final uploadedSource = await SyncMediaSourceApplier.uploadSource(
        source: source,
        bucket: bucket,
        remotePath: (storedMedia) => remotePath(storedMedia, storedMediaIndex),
        upsert: upsert,
      );

      if (uploadedSource == null || uploadedSource == source) continue;
      replacements.add(
        _MarkdownMediaReplacement(
          start: match.start,
          end: match.end,
          value: '${match.group(1)}$uploadedSource${match.group(3)}',
        ),
      );
    }

    if (replacements.isEmpty) return markdown;

    final buffer = StringBuffer();
    var cursor = 0;
    for (final replacement in replacements) {
      buffer
        ..write(markdown.substring(cursor, replacement.start))
        ..write(replacement.value);
      cursor = replacement.end;
    }
    buffer.write(markdown.substring(cursor));
    return buffer.toString();
  }
}

class _MarkdownMediaReplacement {
  const _MarkdownMediaReplacement({
    required this.start,
    required this.end,
    required this.value,
  });

  final int start;
  final int end;
  final String value;
}
