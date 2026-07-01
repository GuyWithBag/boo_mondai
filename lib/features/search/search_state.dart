import 'package:boo_mondai/lib.barrel.dart'
    show FilteredSearchBarController, SearchFilter, SearchScope;

class SearchState<TValue, TObject, TFilter extends SearchFilter> {
  SearchState({
    required this.scope,
    required this.initialText,
    this.initialFilter,
    Iterable<TObject> items = const [],
  }) : controller = FilteredSearchBarController<TObject, TFilter>(
         filterCodec: scope.filterCodec,
         searchResults: scope.searchResults,
         items: items,
         initialText: initialText,
         initialFilter: initialFilter,
       );

  final SearchScope<TValue, TObject, TFilter> scope;
  final String initialText;
  final TFilter? initialFilter;
  final FilteredSearchBarController<TObject, TFilter> controller;

  bool get hasSearchQuery => controller.text.trim().isNotEmpty;
  List<TObject> get results => controller.results;

  void setItems(Iterable<TObject> items) {
    controller.setItems(items);
  }

  void dispose() {
    controller.dispose();
  }
}
