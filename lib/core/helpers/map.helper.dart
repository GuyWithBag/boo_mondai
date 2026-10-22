abstract final class MapHelper {
  static Map<String, dynamic> normalizeKeysToString(Map<dynamic, dynamic> map) {
    return {for (final entry in map.entries) entry.key.toString(): entry.value};
  }

  static Map<String, dynamic> removeKeysDeep(
    Map<dynamic, dynamic> map,
    Set<String> keysToRemove,
  ) {
    return {
      for (final entry in map.entries)
        if (!keysToRemove.contains(entry.key.toString()))
          entry.key.toString(): removeKeysFromValue(entry.value, keysToRemove),
    };
  }

  static Object? removeKeysFromValue(Object? value, Set<String> keysToRemove) {
    return switch (value) {
      final Map<dynamic, dynamic> map => removeKeysDeep(map, keysToRemove),
      final List<dynamic> list => [
        for (final item in list) removeKeysFromValue(item, keysToRemove),
      ],
      _ => value,
    };
  }

  static void requireKeysOrThrowException(
    Map<String, dynamic> map,
    Set<String> keys,
  ) {
    for (final key in keys) {
      if (!map.containsKey(key)) {
        throw FormatException('Import is missing required key: $key');
      }
    }
  }

  static Map<String, dynamic> normalizeWithBaseMap({
    required Map<String, dynamic> base,
    required Map<String, dynamic> imported,
    required Map<String, dynamic> injectValues,
    Set<String> removeKeys = const {},
    Set<String> requiredKeys = const {},
  }) {
    requireKeysOrThrowException(imported, requiredKeys);

    final cleanedBase = {
      for (final entry in base.entries)
        if (!removeKeys.contains(entry.key)) entry.key: entry.value,
    };
    final allowedKeys = cleanedBase.keys.toSet();
    final cleanedImported = {
      for (final entry in imported.entries)
        if (allowedKeys.contains(entry.key) &&
            !removeKeys.contains(entry.key) &&
            !isKeyId(entry.key))
          entry.key: entry.value,
    };

    return {...cleanedBase, ...cleanedImported, ...injectValues};
  }

  static List<Map<String, dynamic>> requireNestedMaps(
    Map<String, dynamic> imported,
    String key,
    String label,
  ) {
    requireKeysOrThrowException(imported, {key});

    final value = imported[key];
    if (value is! List) {
      throw FormatException('$label must be a list.');
    }

    return [
      for (final item in value)
        if (item is Map<dynamic, dynamic>)
          MapHelper.normalizeKeysToString(item)
        else
          throw FormatException('$label must only contain objects.'),
    ];
  }

  static bool isKeyId(String key) {
    final normalized = key.trim().toLowerCase();
    return normalized == 'id' ||
        normalized.endsWith('_id') ||
        normalized.endsWith('id');
  }
}
