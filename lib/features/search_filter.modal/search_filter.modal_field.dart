import 'package:boo_mondai/features/search/models/search.token_shape.dart';
import 'package:boo_mondai/features/search/models/search_tokens.dart';
import 'package:flutter/material.dart';

typedef SearchTokenFieldBuilder =
    Widget Function(
      BuildContext context,
      SearchTokens tokens,
      List<String> values,
      ValueChanged<List<String>> onChanged,
    );

final class SearchTokenModalField {
  const SearchTokenModalField({
    required this.tokenShape,
    required this.label,
    required this.buildEditor,
  });

  final SearchTokenShape tokenShape;
  final String label;
  final SearchTokenFieldBuilder buildEditor;
}
