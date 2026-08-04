import 'package:boo_mondai/lib.barrel.dart'
    show ResearcherSurveyFilter, SearchFilterCodec, SearchFilterModalField;

final class ResearcherSurveyFilterCodec
    implements SearchFilterCodec<ResearcherSurveyFilter> {
  const ResearcherSurveyFilterCodec();

  @override
  ResearcherSurveyFilter parse(String input) =>
      ResearcherSurveyFilter.parse(input);

  @override
  String format(ResearcherSurveyFilter filter) => filter.toSearchText();

  @override
  List<SearchFilterModalField<ResearcherSurveyFilter>> get modalFields =>
      const [];
}
