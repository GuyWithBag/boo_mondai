import 'package:boo_mondai/features/search/filters/card_template.search_filter.dart';
import 'package:boo_mondai/features/search/filters/search_filter_codec.dart';

final class CardTemplateSearchFilterCodec
    implements SearchFilterCodec<CardTemplateSearchFilter> {
  const CardTemplateSearchFilterCodec();

  @override
  CardTemplateSearchFilter parse(String input) {
    return CardTemplateSearchFilter.parse(input);
  }

  @override
  String format(CardTemplateSearchFilter filter) => filter.toSearchText();
}
