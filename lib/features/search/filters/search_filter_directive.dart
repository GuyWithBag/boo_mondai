import 'package:boo_mondai/features/search/search_directive_property.dart';

final class SearchFilterDirective {
  const SearchFilterDirective({
    required this.name,
    this.aliases = const [],
    this.order = 0,
  });

  final String name;
  final List<String> aliases;
  final int order;

  String get normalizedName => SearchDirectiveProperty.normalize(name);

  bool matches(String value) {
    final normalizedValue = SearchDirectiveProperty.normalize(value);
    if (normalizedValue == normalizedName) return true;

    return aliases.any(
      (alias) => SearchDirectiveProperty.normalize(alias) == normalizedValue,
    );
  }
}
