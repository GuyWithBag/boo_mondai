import 'package:boo_mondai/core/helpers/casing.helper.dart';

final class SearchTokenShape {
  const SearchTokenShape({
    required this.name,
    this.aliases = const [],
    this.order = 0,
  });

  final String name;
  final List<String> aliases;
  final int order;

  bool matches(String value) {
    final normalizedValue = CasingHelper.toSnakeCase(value);
    if (normalizedValue == CasingHelper.toSnakeCase(name)) return true;

    return aliases.any(
      (alias) => CasingHelper.toSnakeCase(alias) == normalizedValue,
    );
  }
}
