import 'package:boo_mondai/features/search/filters/deck_listing.search_filter.dart';
import 'package:boo_mondai/features/search/filters/search_filter_codec.dart';

final class DeckListingSearchFilterCodec
    implements SearchFilterCodec<DeckListingSearchFilter> {
  const DeckListingSearchFilterCodec();

  @override
  DeckListingSearchFilter parse(String input) {
    return DeckListingSearchFilter.parse(input);
  }

  @override
  String format(DeckListingSearchFilter filter) => filter.toSearchText();
}
