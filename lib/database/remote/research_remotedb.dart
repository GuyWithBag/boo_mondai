// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_research_service.dart
// PURPOSE: Supabase operations for research codes, surveys, vocab tests, profiles
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/database/database.barrel.dart';

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

  /// Validates the code, marks it as used, and returns the updated code row.
  Future<ResearchCode> redeemResearchCode(String code, String userId) =>
      guard(() async {
        final codeRow = await client
            .from(tableName)
            .select()
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

        return fromMap(Map<String, dynamic>.from(codeRow));
      }, action: 'redeemResearchCode($code, $userId)');

  Future<ResearchData> fetchAllResearchData() => guard(() async {
    final results = await Future.wait([
      client.from('research_profiles').select(),
      client.from('research_codes').select(),
      client
          .from('survey_responses')
          .select()
          .order('submitted_at', ascending: false),
      client
          .from('vocabulary_test_results')
          .select()
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
