abstract final class PathHelper {
  static String getLastPathSegmentOrFallback(
    String? path,
    String fallback, {
    String separator = '/',
  }) {
    final value = path?.trim();
    if (value == null || value.isEmpty) return fallback;

    final segments = value
        .split(separator)
        .map((segment) => segment.trim())
        .where((segment) => segment.isNotEmpty)
        .toList(growable: false);

    if (segments.isEmpty) return fallback;
    return segments.last;
  }
}
