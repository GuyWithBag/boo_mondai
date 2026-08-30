import 'dart:developer' as developer;

import 'package:boo_mondai/lib.barrel.dart'
    show
        Controller,
        LocalDB,
        RemoteDB,
        Survey,
        SurveyBlock,
        SurveyBooleanInputBlock,
        SurveyLikertInputBlock,
        SurveyMultipleChoiceInputBlock,
        SurveyNumberInputBlock,
        SurveyRegistry,
        SurveyResponse,
        SurveyPage,
        SurveyTextInputBlock,
        uuid;

final class ViewSurveyPageData {
  const ViewSurveyPageData({required this.page, required this.blocks});

  final SurveyPage page;
  final List<SurveyBlock> blocks;
}

final class ViewSurveyController extends Controller {
  Survey? survey;
  List<ViewSurveyPageData> pages = const [];
  int pageIndex = 0;
  bool isSubmitted = false;

  final Map<String, dynamic> answers = {};

  bool get canGoBack => pageIndex > 0 && !isSubmitted;
  bool get isLastPage => pageIndex == pages.length - 1;
  double get progress => pages.isEmpty ? 0 : (pageIndex + 1) / pages.length;
  ViewSurveyPageData? get currentPage =>
      pages.isEmpty ? null : pages[pageIndex];

  Future<void> load(String surveyId) async {
    setLoading(true);
    setError(null);
    notifyListeners();

    try {
      final definition = SurveyRegistry.getById(surveyId);
      if (definition == null) {
        throw Exception('Survey was not found.');
      }
      final profileId = LocalDB.profile.getOrCreate().id;
      final existingResponse = LocalDB.surveyResponse.selectBySurveyAndProfile(
        surveyId: definition.survey.id,
        profileId: profileId,
      );

      survey = definition.survey;
      pages = [
        for (final page in definition.pages)
          ViewSurveyPageData(
            page: page,
            blocks:
                definition.blocks
                    .where((block) => block.pageId == page.id)
                    .toList()
                  ..sort((a, b) => a.position.compareTo(b.position)),
          ),
      ];
      pageIndex = 0;
      isSubmitted = existingResponse != null;
    } catch (e) {
      setError(e is Exception ? e : Exception(e.toString()));
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  void setAnswer(String key, dynamic value) {
    answers[key] = value is String && value.trim().isEmpty ? null : value;
    notifyListeners();
  }

  void next() {
    if (!_validatePage(currentPage)) return;
    if (!isLastPage) {
      pageIndex++;
      notifyListeners();
    }
  }

  void back() {
    if (canGoBack) {
      pageIndex--;
      notifyListeners();
    }
  }

  Future<void> submit() async {
    final loadedSurvey = survey;
    if (loadedSurvey == null) return;
    if (pages.any((page) => !_validatePage(page))) return;

    setLoading(true);
    setError(null);
    notifyListeners();

    try {
      final response = SurveyResponse(
        id: uuid.v7(),
        surveyId: loadedSurvey.id,
        profileId: LocalDB.profile.getOrCreate().id,
        answers: _answersWithNullsForInputBlocks(),
        submittedAt: DateTime.now(),
      );

      await LocalDB.surveyResponse.upsert(response);
      await _pushResponseRemote(response);

      isSubmitted = true;
    } catch (e) {
      setError(e is Exception ? e : Exception(e.toString()));
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  Map<String, dynamic> _answersWithNullsForInputBlocks() {
    final values = Map<String, dynamic>.from(answers);
    for (final page in pages) {
      for (final block in page.blocks) {
        final key = switch (block) {
          SurveyTextInputBlock(:final key) => key,
          SurveyNumberInputBlock(:final key) => key,
          SurveyMultipleChoiceInputBlock(:final key) => key,
          SurveyLikertInputBlock(:final key) => key,
          SurveyBooleanInputBlock(:final key) => key,
          _ => null,
        };
        if (key != null) values.putIfAbsent(key, () => null);
      }
    }
    return values;
  }

  Future<void> _pushResponseRemote(SurveyResponse response) async {
    try {
      await RemoteDB.surveyResponse.upsert(response);
    } catch (error, stackTrace) {
      developer.log(
        'Failed to push survey response remotely.',
        name: 'ViewSurveyController',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  bool _validatePage(ViewSurveyPageData? page) {
    if (page == null) return false;

    for (final block in page.blocks) {
      if (!_isRequiredBlockAnswered(block)) {
        setError(Exception('Please answer all required questions.'));
        notifyListeners();
        return false;
      }
    }

    if (error != null) {
      setError(null);
      notifyListeners();
    }
    return true;
  }

  bool _isRequiredBlockAnswered(SurveyBlock block) {
    return switch (block) {
      SurveyTextInputBlock(:final key, :final isRequired) =>
        !isRequired || ((answers[key] as String?)?.trim().isNotEmpty ?? false),
      SurveyNumberInputBlock(:final key, :final isRequired) =>
        !isRequired || answers[key] is num,
      SurveyMultipleChoiceInputBlock(
        :final key,
        :final isRequired,
        :final minAnswers,
        :final maxAnswers,
      ) =>
        !isRequired ||
            _selectedAnswersInRange(answers[key], minAnswers, maxAnswers),
      SurveyLikertInputBlock(:final key, :final isRequired) =>
        !isRequired || answers[key] is int,
      SurveyBooleanInputBlock(:final key, :final isRequired) =>
        !isRequired || answers[key] is bool,
      _ => true,
    };
  }

  bool _selectedAnswersInRange(dynamic value, int min, int max) {
    if (value is! List) return false;
    return value.length >= min && value.length <= max;
  }
}
