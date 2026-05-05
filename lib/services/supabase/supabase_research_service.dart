// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_research_service.dart
// PURPOSE: Supabase operations for research codes, surveys, vocab tests, profiles
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'supabase_service.dart';

class SupabaseResearchService extends SupabaseService {
  Future<List<Map<String, dynamic>>> fetchResearchCodes({String? createdBy}) =>
      fetchAll(
        'research_codes',
        filters: createdBy != null ? {'createdBy': createdBy} : null,
        orderBy: 'createdAt',
      );

  Future<Map<String, dynamic>> insertResearchCode(Map<String, dynamic> data) =>
      insertOne('research_codes', data);

  /// Validates the code, marks it as used, and returns the original code row.
  Future<Map<String, dynamic>> redeemResearchCode(String code, String userId) =>
      guard(() async {
        final codeRow = await client
            .from('research_codes')
            .select()
            .eq('code', code)
            .isFilter('usedBy', null)
            .single();

        await client
            .from('research_codes')
            .update({
              'usedBy': userId,
              'usedAt': DateTime.now().toIso8601String(),
            })
            .eq('id', codeRow['id'] as String);

        return Map<String, dynamic>.from(codeRow);
      });

  Future<void> insertSurveyResponse(Map<String, dynamic> data) =>
      insertRow('survey_responses', data);

  Future<void> insertVocabularyTest(Map<String, dynamic> data) =>
      insertRow('vocabulary_test_results', data);

  Future<Map<String, List<Map<String, dynamic>>>> fetchAllResearchData() =>
      guard(() async {
        final results = await Future.wait([
          client.from('research_profiles').select(),
          client.from('research_codes').select(),
          client
              .from('survey_responses')
              .select()
              .order('submittedAt', ascending: false),
          client
              .from('vocabulary_test_results')
              .select()
              .order('submittedAt', ascending: false),
        ]);

        return {
          'research_profiles': List<Map<String, dynamic>>.from(results[0]),
          'research_codes': List<Map<String, dynamic>>.from(results[1]),
          'survey_responses': List<Map<String, dynamic>>.from(results[2]),
          'vocabulary_test_results': List<Map<String, dynamic>>.from(
            results[3],
          ),
        };
      });

  Future<void> insertResearchProfile(Map<String, dynamic> data) =>
      insertRow('research_profiles', data);
}
