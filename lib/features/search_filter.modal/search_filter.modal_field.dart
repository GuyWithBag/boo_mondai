import 'package:boo_mondai/lib.barrel.dart'
    show SearchFilter, SearchFilterDirective;
import 'package:flutter/material.dart';

typedef SearchFilterFieldBuilder<TFilter extends SearchFilter> =
    Widget Function(
      BuildContext context,
      TFilter filter,
      ValueChanged<TFilter>,
    );

final class SearchFilterModalField<TFilter extends SearchFilter> {
  const SearchFilterModalField({
    required this.directive,
    required this.label,
    required this.buildEditor,
  });

  final SearchFilterDirective directive;
  final String label;
  final SearchFilterFieldBuilder<TFilter> buildEditor;
}
