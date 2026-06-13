import 'package:boo_mondai/lib.barrel.dart'
    show SearchFilter, FilteredSearchBarController, SearchScope;

class ViewCardsSearchState<TObject, TFilter extends SearchFilter> {
  ViewCardsSearchState({
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

  final SearchScope<TObject, TFilter> scope;
  final String initialText;
  final TFilter? initialFilter;
  final FilteredSearchBarController<TObject, TFilter> controller;

  void setItems(Iterable<TObject> items) {
    controller.setItems(items);
  }

  void dispose() {
    controller.dispose();
  }
}
