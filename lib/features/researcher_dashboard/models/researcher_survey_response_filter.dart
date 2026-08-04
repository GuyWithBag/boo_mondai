import 'package:boo_mondai/lib.barrel.dart' show SearchFilter;

final class ResearcherSurveyResponseFilter implements SearchFilter {
  const ResearcherSurveyResponseFilter({
    required this.freeText,
    this.fuzzyCutoff = 60,
  });

  @override
  final String freeText;

  @override
  final int fuzzyCutoff;

  static ResearcherSurveyResponseFilter parse(String input) {
    return ResearcherSurveyResponseFilter(freeText: input.trim());
  }

  @override
  String toSearchText() => freeText;
}
