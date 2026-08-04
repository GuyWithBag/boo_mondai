import 'dart:developer' as developer;

import 'package:boo_mondai/lib.barrel.dart'
    show
        AuthService,
        Controller,
        LocalDB,
        RemoteDB,
        ResearcherSurveySummary,
        SurveyDefinition,
        SurveyRegistry,
        SurveyResponse;

final class ResearcherDashboardController extends Controller {
  List<SurveyDefinition> surveys = const [];
  List<SurveyResponse> responses = const [];

  List<ResearcherSurveySummary> get summaries {
    return [
      for (final survey in surveys)
        ResearcherSurveySummary(
          definition: survey,
          responses: responses
              .where((response) => response.surveyId == survey.id)
              .toList(),
        ),
    ];
  }

  ResearcherSurveySummary? summaryBySurveyId(String surveyId) {
    for (final summary in summaries) {
      if (summary.id == surveyId) return summary;
    }
    return null;
  }

  Future<void> load() async {
    setLoading(true);
    setError(null);
    notifyListeners();

    try {
      surveys = SurveyRegistry.getAll();
      responses = await _loadResponses();
    } catch (error) {
      setError(error is Exception ? error : Exception(error.toString()));
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  Future<List<SurveyResponse>> _loadResponses() async {
    final local = LocalDB.surveyResponse.selectMany();
    if (!AuthService.isAuthenticatedRemote) return local;

    try {
      final remote = await RemoteDB.surveyResponse.selectMany(
        orderBy: 'submitted_at',
        ascending: false,
      );
      return _mergeResponses(local, remote);
    } catch (error, stackTrace) {
      developer.log(
        'Failed to load remote survey responses for researcher dashboard.',
        name: 'ResearcherDashboardController',
        error: error,
        stackTrace: stackTrace,
      );
      return local;
    }
  }

  List<SurveyResponse> _mergeResponses(
    List<SurveyResponse> local,
    List<SurveyResponse> remote,
  ) {
    final byId = <String, SurveyResponse>{
      for (final response in local) response.id: response,
      for (final response in remote) response.id: response,
    };
    return byId.values.toList()
      ..sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
  }
}
