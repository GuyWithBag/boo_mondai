import 'package:boo_mondai/lib.barrel.dart'
    show
        ResearcherSurveySummary,
        SearchTokenShape,
        SearchTokens,
        SurveyResponse;

abstract final class ResearcherSurveySummarySearch {
  static const fuzzy = SearchTokenShape(name: 'fuzzy', aliases: ['cutoff']);
  static const tokenShapes = [fuzzy];

  static String searchTextLabel(ResearcherSurveySummary summary) => [
    summary.id,
    summary.title,
    summary.description,
    summary.responseCount.toString(),
    summary.lastSubmittedAt?.toIso8601String(),
  ].whereType<String>().join(' ');

  static List<ResearcherSurveySummary> sorter(
    List<ResearcherSurveySummary> summaries,
    SearchTokens tokens,
  ) {
    final sorted = [...summaries];
    sorted.sort((a, b) {
      final aDate = a.lastSubmittedAt;
      final bDate = b.lastSubmittedAt;
      if (aDate == null && bDate == null) {
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      }
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return bDate.compareTo(aDate);
    });
    return sorted;
  }
}

abstract final class ResearcherSurveyResponseSearch {
  static const fuzzy = SearchTokenShape(name: 'fuzzy', aliases: ['cutoff']);
  static const tokenShapes = [fuzzy];

  static String searchTextLabel(SurveyResponse response) {
    return [
      response.id,
      response.surveyId,
      response.profileId,
      response.submittedAt.toIso8601String(),
      for (final entry in response.answers.entries) entry.key,
      for (final value in response.answers.values) value.toString(),
    ].join(' ');
  }

  static List<SurveyResponse> sorter(
    List<SurveyResponse> responses,
    SearchTokens tokens,
  ) {
    final sorted = [...responses];
    sorted.sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
    return sorted;
  }
}
