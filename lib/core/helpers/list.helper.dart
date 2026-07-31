abstract final class ListHelper {
  static List<T> replaceAt<T>(List<T> values, int index, T value) {
    return [
      for (var i = 0; i < values.length; i++)
        if (i == index) value else values[i],
    ];
  }

  static List<T> removeAt<T>(List<T> values, int index) {
    return [
      for (var i = 0; i < values.length; i++)
        if (i != index) values[i],
    ];
  }

  static T? getAtOrNull<T>(List<T> values, int index) {
    if (index < 0 || index >= values.length) return null;
    return values[index];
  }

  static Map<K, List<T>> groupBy<T, K>(
    Iterable<T> values,
    K Function(T value) keyOf,
  ) {
    final grouped = <K, List<T>>{};
    for (final value in values) {
      (grouped[keyOf(value)] ??= <T>[]).add(value);
    }
    return grouped;
  }
}
