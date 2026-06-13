import 'package:boo_mondai/lib.barrel.dart'
    show SearchFilter, SearchFilterModalField;

abstract interface class SearchFilterCodec<TFilter extends SearchFilter> {
  TFilter parse(String input);
  String format(TFilter filter);
  List<SearchFilterModalField<TFilter>> get modalFields;
}
