abstract final class SearchDirectiveProperty {
  static String normalize(String property) {
    return property.trim().toLowerCase().replaceAll(RegExp('[-_]'), '');
  }
}
