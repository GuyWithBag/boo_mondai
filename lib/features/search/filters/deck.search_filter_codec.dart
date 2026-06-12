import 'package:boo_mondai/features/search/filters/deck.search_filter.dart';
import 'package:boo_mondai/features/search/filters/search_filter_codec.dart';

final class DeckSearchFilterCodec
    implements SearchFilterCodec<DeckSearchFilter> {
  const DeckSearchFilterCodec();

  @override
  DeckSearchFilter parse(String input) => DeckSearchFilter.parse(input);

  @override
  String format(DeckSearchFilter filter) => filter.toSearchText();
}
