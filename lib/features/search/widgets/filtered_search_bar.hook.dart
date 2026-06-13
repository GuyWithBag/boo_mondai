import 'package:boo_mondai/lib.barrel.dart'
    show
        FilteredSearchBarController,
        SearchFilter,
        SearchFilterCodec,
        SearchResults;
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

FilteredSearchBarController<TObject, TFilter>
useFilteredSearchBarController<TObject, TFilter extends SearchFilter>({
  required SearchFilterCodec<TFilter> filterCodec,
  required SearchResults<TObject, TFilter> searchResults,
  Iterable<TObject> items = const [],
  String initialText = '',
  TFilter? initialFilter,
}) {
  final controller = useMemoized(
    () => FilteredSearchBarController<TObject, TFilter>(
      filterCodec: filterCodec,
      searchResults: searchResults,
      items: items,
      initialText: initialText,
      initialFilter: initialFilter,
    ),
    [filterCodec, searchResults],
  );

  useEffect(() {
    var isActive = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isActive) return;
      controller.setItems(items);
    });

    return () => isActive = false;
  }, [controller, items]);

  useListenable(controller);
  useEffect(() => controller.dispose, [controller]);

  return controller;
}
