abstract interface class SearchFilter {
  String get freeText;
  int get fuzzyCutoff;

  String toSearchText();
}
