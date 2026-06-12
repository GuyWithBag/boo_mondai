import 'package:boo_mondai/features/search/filters/search_filter.dart';

abstract interface class SearchFilterCodec<TFilter extends SearchFilter> {
  TFilter parse(String input);
  String format(TFilter filter);
}
