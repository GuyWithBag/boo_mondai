import 'package:boo_mondai/lib.barrel.dart' show SearchFilter;

abstract interface class SearchResults<TObject, TFilter extends SearchFilter> {
  List<TObject> resolve({
    required Iterable<TObject> items,
    required TFilter filter,
  });
}
