import 'package:boo_mondai/lib.barrel.dart'
    show SearchFilterCodec, SearchResults, SearchFilter;

class SearchScopeOption<TValue> {
  const SearchScopeOption({required this.value, required this.label});

  final TValue value;
  final String label;
}

class SearchScope<TValue, TObject, TFilter extends SearchFilter> {
  const SearchScope({
    required this.value,
    required this.label,
    required this.filterCodec,
    required this.searchResults,
    required this.items,
  });

  final TValue value;
  final String label;
  final SearchFilterCodec<TFilter> filterCodec;
  final SearchResults<TObject, TFilter> searchResults;
  final Iterable<TObject> items;

  SearchScopeOption<TValue> get option {
    return SearchScopeOption(value: value, label: label);
  }
}
