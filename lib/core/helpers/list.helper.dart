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
}
