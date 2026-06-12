import 'package:boo_mondai/features/search/filters/search_filter.dart';

abstract interface class SearchResults<TObject, TFilter extends SearchFilter> {
  List<TObject> resolve({
    required Iterable<TObject> items,
    required TFilter filter,
  });
}
