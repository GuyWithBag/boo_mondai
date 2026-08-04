import 'package:boo_mondai/lib.barrel.dart'
    show
        ResearcherSurveyResponseFilter,
        SearchFilterCodec,
        SearchFilterModalField;

final class ResearcherSurveyResponseFilterCodec
    implements SearchFilterCodec<ResearcherSurveyResponseFilter> {
  const ResearcherSurveyResponseFilterCodec();

  @override
  ResearcherSurveyResponseFilter parse(String input) {
    return ResearcherSurveyResponseFilter.parse(input);
  }

  @override
  String format(ResearcherSurveyResponseFilter filter) {
    return filter.toSearchText();
  }

  @override
  List<SearchFilterModalField<ResearcherSurveyResponseFilter>>
  get modalFields => const [];
}
