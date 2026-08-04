import 'package:boo_mondai/lib.barrel.dart'
    show ResearcherSurveyResponseFilter, SearchResults, SurveyResponse;

final class ResearcherSurveyResponseSearchResults
    implements SearchResults<SurveyResponse, ResearcherSurveyResponseFilter> {
  const ResearcherSurveyResponseSearchResults();

  @override
  List<SurveyResponse> resolve({
    required Iterable<SurveyResponse> items,
    required ResearcherSurveyResponseFilter filter,
  }) {
    final query = filter.freeText.trim().toLowerCase();
    final responses = items.where((response) {
      if (query.isEmpty) return true;
      return _searchText(response).contains(query);
    }).toList();

    responses.sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
    return responses;
  }

  String _searchText(SurveyResponse response) {
    return [
      response.id,
      response.surveyId,
      response.profileId,
      response.submittedAt.toIso8601String(),
      for (final entry in response.answers.entries) entry.key,
      for (final value in response.answers.values) value.toString(),
    ].join(' ').toLowerCase();
  }
}
