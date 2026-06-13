import 'package:boo_mondai/lib.barrel.dart'
    show SearchFilterCodec, SearchResults, SearchFilter;

class SearchScope<TObject, TFilter extends SearchFilter> {
  const SearchScope({
    required this.id,
    required this.label,
    required this.filterCodec,
    required this.searchResults,
    required this.items,
  });

  final String id;
  final String label;
  final SearchFilterCodec<TFilter> filterCodec;
  final SearchResults<TObject, TFilter> searchResults;
  final Iterable<TObject> items;
}
