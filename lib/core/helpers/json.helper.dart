import 'package:boo_mondai/lib.barrel.dart' show MapHelper;

abstract final class JsonHelper {
  static List<Map<String, dynamic>> jsonDecodeToListMap(Object? decoded) {
    if (decoded is Map<dynamic, dynamic>) {
      return [MapHelper.normalizeKeysToString(decoded)];
    }

    if (decoded is List) {
      return [
        for (final item in decoded)
          if (item is Map<dynamic, dynamic>)
            MapHelper.normalizeKeysToString(item)
          else
            throw const FormatException(
              'Import JSON arrays must only contain objects.',
            ),
      ];
    }

    throw const FormatException('Import JSON must be an object or array.');
  }

  static bool isTextJson(String text) {
    final trimmed = text.trimLeft();
    return trimmed.startsWith('{') || trimmed.startsWith('[');
  }
}
