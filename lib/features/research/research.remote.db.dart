// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_research_service.dart
// PURPOSE: Supabase operations for research codes, surveys, vocab tests, profiles
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        ResearchCode,
        SurveyResponse,
        ResearchProfile,
        VocabularyTestResult,
        SupabaseRemoteDB,
        ResearchCodeMapper,
        ResearchProfileMapper,
        SurveyResponseMapper,
        VocabularyTestResultMapper;

/// Typed aggregate returned by [ResearchRemoteDB.fetchAllResearchData].
class ResearchData {
  final List<ResearchProfile> profiles;
  final List<ResearchCode> codes;
  final List<SurveyResponse> responses;
  final List<VocabularyTestResult> testResults;

  const ResearchData({
    required this.profiles,
    required this.codes,
    required this.responses,
    required this.testResults,
  });
}

class ResearchRemoteDB extends SupabaseRemoteDB<ResearchCode> {
  @override
  String get tableName => 'research_codes';

  @override
  ResearchCode Function(Map<String, dynamic>) get fromMap =>
      ResearchCodeMapper.fromMap;
  @override
  Map<String, dynamic> toMap(ResearchCode item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(ResearchCode item) => {'id': item.id};

  @override
  String get upsertConflictTarget => 'id';

  @override
  String get defaultSelect => _researchCodeWithRelationsSelect;

  @override
  Set<String> get joinedFields => const {
    'createdByProfile',
    'created_by_profile',
    'usedByProfile',
    'used_by_profile',
  };

  /// Validates the code, marks it as used, and returns the updated code row.
  Future<ResearchCode> redeemResearchCode(String code, String userId) =>
      guard(() async {
        final codeRow = await client
            .from(tableName)
            .select(_researchCodeWithRelationsSelect)
            .eq('code', code)
            .isFilter('used_by', null)
            .single();

        await client
            .from(tableName)
            .update({
              'used_by': userId,
              'used_at': DateTime.now().toIso8601String(),
            })
            .eq('id', codeRow['id'] as String);

        return fromJoinedMap(Map<String, dynamic>.from(codeRow));
      }, action: 'redeemResearchCode($code, $userId)');

  Future<ResearchData> fetchAllResearchData() => guard(() async {
    final results = await Future.wait([
      client
          .from('research_profiles')
          .select(_researchProfileWithRelationsSelect),
      client.from('research_codes').select(_researchCodeWithRelationsSelect),
      client
          .from('survey_responses')
          .select(_surveyResponseWithRelationsSelect)
          .order('submitted_at', ascending: false),
      client
          .from('vocabulary_test_results')
          .select(_vocabularyTestResultWithRelationsSelect)
          .order('submitted_at', ascending: false),
    ]);

    return ResearchData(
      profiles: List<Map<String, dynamic>>.from(
        results[0],
      ).map(ResearchProfileMapper.fromMap).toList(),
      codes: List<Map<String, dynamic>>.from(
        results[1],
      ).map(ResearchCodeMapper.fromMap).toList(),
      responses: List<Map<String, dynamic>>.from(
        results[2],
      ).map(SurveyResponseMapper.fromMap).toList(),
      testResults: List<Map<String, dynamic>>.from(
        results[3],
      ).map(VocabularyTestResultMapper.fromMap).toList(),
    );
  }, action: 'fetchAllResearchData()');
}

const _researchProfileWithRelationsSelect =
    '*, user_profile:profiles(id, username, avatar_url, created_at)';

const _researchCodeWithRelationsSelect =
    '*, created_by_profile:profiles!research_codes_created_by_fkey(id, username, avatar_url, created_at), used_by_profile:profiles!research_codes_used_by_fkey(id, username, avatar_url, created_at)';

const _surveyResponseWithRelationsSelect =
    '*, user_profile:profiles!survey_responses_user_id_fkey(id, username, avatar_url, created_at), research_profile:research_profiles!survey_responses_research_profile_user_id_fkey(*)';

const _vocabularyTestResultWithRelationsSelect =
    '*, user_profile:profiles!vocabulary_test_results_user_id_fkey(id, username, avatar_url, created_at), research_profile:research_profiles!vocabulary_test_results_research_profile_user_id_fkey(*)';
