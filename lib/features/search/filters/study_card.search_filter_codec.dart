import 'package:boo_mondai/features/search/filters/search_filter_codec.dart';
import 'package:boo_mondai/features/search/filters/study_card.search_filter.dart';

final class StudyCardSearchFilterCodec
    implements SearchFilterCodec<StudyCardSearchFilter> {
  const StudyCardSearchFilterCodec();

  @override
  StudyCardSearchFilter parse(String input) {
    return StudyCardSearchFilter.parse(input);
  }

  @override
  String format(StudyCardSearchFilter filter) => filter.toSearchText();
}
