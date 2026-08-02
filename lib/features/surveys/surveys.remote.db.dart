import 'package:boo_mondai/lib.barrel.dart'
    show
        SupabaseRemoteDB,
        Survey,
        SurveyMapper,
        SurveyQuestion,
        SurveyQuestionMapper,
        SurveyMultipleChoiceQuestion,
        SurveyChoiceOption,
        SurveyChoiceOptionMapper,
        SurveyAssignment,
        SurveyAssignmentMapper,
        SurveyResponse,
        SurveyResponseMapper;

class SurveysRemoteDB extends SupabaseRemoteDB<Survey> {
  @override
  String get tableName => 'surveys';

  @override
  Survey Function(Map<String, dynamic>) get fromMap => SurveyMapper.fromMap;

  @override
  Map<String, dynamic> toMap(Survey item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(Survey item) => {'id': item.id};

  @override
  String get upsertConflictTarget => 'id';
}

class SurveyQuestionsRemoteDB extends SupabaseRemoteDB<SurveyQuestion> {
  @override
  String get tableName => 'survey_questions';

  @override
  SurveyQuestion Function(Map<String, dynamic>) get fromMap =>
      SurveyQuestionMapper.fromMap;

  @override
  Map<String, dynamic> toMap(SurveyQuestion item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(SurveyQuestion item) => {
    'id': item.id,
  };

  @override
  String get upsertConflictTarget => 'id';

  @override
  String get defaultSelect => '*, options:survey_question_options(*)';

  @override
  Set<String> get joinedFields => const {'options'};

  @override
  SurveyQuestion fromJoinedMap(Map<String, dynamic> map) {
    final options = map['options'];
    if (options is List) {
      map['options'] = List<Map<String, dynamic>>.from(
        options,
      )..sort((a, b) => (a['position'] as int).compareTo(b['position'] as int));
    }
    return fromMap(map);
  }

  @override
  Map<String, dynamic> toWriteMap(SurveyQuestion item) {
    final map = super.toWriteMap(item);
    if (item is! SurveyMultipleChoiceQuestion) {
      map.remove('min_answers');
      map.remove('max_answers');
    }
    return map;
  }
}

class SurveyQuestionOptionsRemoteDB
    extends SupabaseRemoteDB<SurveyChoiceOption> {
  @override
  String get tableName => 'survey_question_options';

  @override
  SurveyChoiceOption Function(Map<String, dynamic>) get fromMap =>
      SurveyChoiceOptionMapper.fromMap;

  @override
  Map<String, dynamic> toMap(SurveyChoiceOption item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(SurveyChoiceOption item) => {
    'id': item.id,
  };

  @override
  String get upsertConflictTarget => 'id';
}

class SurveyAssignmentsRemoteDB extends SupabaseRemoteDB<SurveyAssignment> {
  @override
  String get tableName => 'survey_assignments';

  @override
  SurveyAssignment Function(Map<String, dynamic>) get fromMap =>
      SurveyAssignmentMapper.fromMap;

  @override
  Map<String, dynamic> toMap(SurveyAssignment item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(SurveyAssignment item) => {
    'id': item.id,
  };

  @override
  String get upsertConflictTarget => 'id';
}

class SurveyResponsesRemoteDB extends SupabaseRemoteDB<SurveyResponse> {
  @override
  String get tableName => 'survey_submissions';

  @override
  SurveyResponse Function(Map<String, dynamic>) get fromMap =>
      SurveyResponseMapper.fromMap;

  @override
  Map<String, dynamic> toMap(SurveyResponse item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(SurveyResponse item) => {
    'id': item.id,
  };

  @override
  String get upsertConflictTarget => 'id';
}
