import 'package:boo_mondai/lib.barrel.dart'
    show
        Controller,
        RemoteDB,
        Survey,
        SurveyAssignment,
        SurveyAssignmentStatus,
        SurveyBlock,
        SurveyBooleanInputBlock,
        SurveyLikertInputBlock,
        SurveyMultipleChoiceInputBlock,
        SurveyNumberInputBlock,
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
  SurveyAssignment? assignment;
  List<ViewSurveyPageData> pages = const [];
  int pageIndex = 0;
  bool isSubmitted = false;

  final Map<String, dynamic> answers = {};

  bool get canGoBack => pageIndex > 0 && !isSubmitted;
  bool get isLastPage => pageIndex == pages.length - 1;
  double get progress => pages.isEmpty ? 0 : (pageIndex + 1) / pages.length;
  ViewSurveyPageData? get currentPage =>
      pages.isEmpty ? null : pages[pageIndex];

  Future<void> load(String assignmentId) async {
    setLoading(true);
    setError(null);
    notifyListeners();

    try {
      final loadedAssignment = await RemoteDB.surveyAssignment.selectOne(
        filters: {'id': assignmentId},
      );
      if (loadedAssignment == null) {
        throw Exception('Survey assignment was not found.');
      }

      final loadedSurvey = await RemoteDB.survey.selectOne(
        filters: {'id': loadedAssignment.surveyId},
      );
      if (loadedSurvey == null) {
        throw Exception('Survey was not found.');
      }

      final loadedPages = await RemoteDB.surveyPage.selectMany(
        filters: {'survey_id': loadedSurvey.id},
        orderBy: 'position',
      );
      final loadedBlocks = await RemoteDB.surveyBlock.selectMany(
        filters: {'survey_id': loadedSurvey.id},
        orderBy: 'position',
      );

      survey = loadedSurvey;
      assignment = loadedAssignment;
      pages = [
        for (final page in loadedPages)
          ViewSurveyPageData(
            page: page,
            blocks:
                loadedBlocks.where((block) => block.pageId == page.id).toList()
                  ..sort((a, b) => a.position.compareTo(b.position)),
          ),
      ];
      pageIndex = 0;
      isSubmitted = loadedAssignment.status == SurveyAssignmentStatus.completed;
    } catch (e) {
      setError(e is Exception ? e : Exception(e.toString()));
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  void setAnswer(String key, dynamic value) {
    if (value == null || (value is String && value.trim().isEmpty)) {
      answers.remove(key);
    } else {
      answers[key] = value;
    }
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
    final loadedAssignment = assignment;
    if (loadedSurvey == null || loadedAssignment == null) return;
    if (pages.any((page) => !_validatePage(page))) return;

    setLoading(true);
    setError(null);
    notifyListeners();

    try {
      await RemoteDB.surveyResponse.insert(
        SurveyResponse(
          id: uuid.v7(),
          surveyId: loadedSurvey.id,
          profileId: loadedAssignment.profileId,
          assignmentId: loadedAssignment.id,
          answers: Map<String, dynamic>.from(answers),
          submittedAt: DateTime.now(),
        ),
      );

      await RemoteDB.surveyAssignment.updateWhere(
        filters: {'id': loadedAssignment.id},
        values: {
          'status': SurveyAssignmentStatus.completed.name,
          'completed_at': DateTime.now().toIso8601String(),
        },
      );

      isSubmitted = true;
    } catch (e) {
      setError(e is Exception ? e : Exception(e.toString()));
    } finally {
      setLoading(false);
      notifyListeners();
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
