import 'package:boo_mondai/lib.barrel.dart'
    show ResearcherSurveyFilter, ResearcherSurveySummary, SearchResults;

final class ResearcherSurveySearchResults
    implements SearchResults<ResearcherSurveySummary, ResearcherSurveyFilter> {
  const ResearcherSurveySearchResults();

  @override
  List<ResearcherSurveySummary> resolve({
    required Iterable<ResearcherSurveySummary> items,
    required ResearcherSurveyFilter filter,
  }) {
    final query = filter.freeText.trim().toLowerCase();
    final filtered = items.where((summary) {
      if (filter.onlyWithResponses && summary.responseCount == 0) return false;
      if (query.isEmpty) return true;

      final haystack = [
        summary.id,
        summary.title,
        summary.description,
        for (final block in summary.definition.blocks) block.toString(),
      ].join(' ').toLowerCase();

      return haystack.contains(query);
    }).toList();

    filtered.sort((a, b) {
      final responseComparison = b.responseCount.compareTo(a.responseCount);
      if (responseComparison != 0) return responseComparison;
      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });
    return filtered;
  }
}
