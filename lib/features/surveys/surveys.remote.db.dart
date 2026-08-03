import 'package:boo_mondai/lib.barrel.dart'
    show
        SupabaseRemoteDB,
        Survey,
        SurveyMapper,
        SurveyPage,
        SurveyPageMapper,
        SurveyBlock,
        SurveyBlockMapper,
        SurveyMultipleChoiceInputBlock,
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

class SurveyPagesRemoteDB extends SupabaseRemoteDB<SurveyPage> {
  @override
  String get tableName => 'survey_pages';

  @override
  SurveyPage Function(Map<String, dynamic>) get fromMap =>
      SurveyPageMapper.fromMap;

  @override
  Map<String, dynamic> toMap(SurveyPage item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(SurveyPage item) => {'id': item.id};

  @override
  String get upsertConflictTarget => 'id';
}

class SurveyBlocksRemoteDB extends SupabaseRemoteDB<SurveyBlock> {
  @override
  String get tableName => 'survey_blocks';

  @override
  SurveyBlock Function(Map<String, dynamic>) get fromMap =>
      SurveyBlockMapper.fromMap;

  @override
  Map<String, dynamic> toMap(SurveyBlock item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(SurveyBlock item) => {'id': item.id};

  @override
  String get upsertConflictTarget => 'id';

  @override
  String get defaultSelect => '*, options:survey_block_options(*)';

  @override
  Set<String> get joinedFields => const {'options'};

  @override
  SurveyBlock fromJoinedMap(Map<String, dynamic> map) {
    final options = map['options'];
    if (options is List) {
      map['options'] = List<Map<String, dynamic>>.from(
        options,
      )..sort((a, b) => (a['position'] as int).compareTo(b['position'] as int));
    }
    return fromMap(map);
  }

  @override
  Map<String, dynamic> toWriteMap(SurveyBlock item) {
    final map = super.toWriteMap(item);
    if (item is! SurveyMultipleChoiceInputBlock) {
      map.remove('min_answers');
      map.remove('max_answers');
    }
    return map;
  }
}

class SurveyBlockOptionsRemoteDB extends SupabaseRemoteDB<SurveyChoiceOption> {
  @override
  String get tableName => 'survey_block_options';

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
