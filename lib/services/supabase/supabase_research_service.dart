// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_research_service.dart
// PURPOSE: Supabase operations for research codes, surveys, vocab tests, users
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'supabase_service.dart';

class SupabaseResearchService extends SupabaseService {
  Future<List<Map<String, dynamic>>> fetchResearchCodes({
    String? createdBy,
  }) =>
      guard(() async {
        var query = client.from('research_codes').select();
        if (createdBy != null) {
          query = query.eq('created_by', createdBy);
        }
        final response =
            await query.order('created_at', ascending: false);
        return List<Map<String, dynamic>>.from(response);
      });

  Future<Map<String, dynamic>> insertResearchCode(
          Map<String, dynamic> data) =>
      guard(
          () => client.from('research_codes').insert(data).select().single());

  Future<Map<String, dynamic>> redeemResearchCode(
      String code, String userId) =>
      guard(() async {
        final codeRow = await client
            .from('research_codes')
            .select()
            .eq('code', code)
            .isFilter('used_by', null)
            .single();

        await client.from('research_codes').update({
          'used_by': userId,
          'used_at': DateTime.now().toIso8601String(),
        }).eq('id', codeRow['id']);

        return codeRow;
      });

  Future<void> insertSurveyResponse(
          String table, Map<String, dynamic> data) =>
      guard(() => client.from(table).insert(data));

  Future<void> insertVocabularyTest(Map<String, dynamic> data) =>
      guard(() => client.from('research_vocabulary_test').insert(data));

  Future<Map<String, List<Map<String, dynamic>>>>
      fetchAllResearchData() =>
          guard(() async {
            final results = await Future.wait([
              client.from('research_users').select(
                  '*, profiles:user_id(display_name)'),
              client.from('research_codes').select(),
              client.from('research_proficiency_screener').select(),
              client.from('research_language_interest').select(),
              client.from('research_vocabulary_test').select(),
              client.from('research_experience_survey').select(),
              client.from('research_preview_usefulness').select(),
              client.from('research_fsrs_usefulness').select(),
              client.from('research_ugc_perception').select(),
              client.from('research_sus').select(),
            ]);

            return {
              'research_users':
                  List<Map<String, dynamic>>.from(results[0]),
              'research_codes':
                  List<Map<String, dynamic>>.from(results[1]),
              'proficiency_screener':
                  List<Map<String, dynamic>>.from(results[2]),
              'language_interest':
                  List<Map<String, dynamic>>.from(results[3]),
              'vocabulary_test':
                  List<Map<String, dynamic>>.from(results[4]),
              'experience_survey':
                  List<Map<String, dynamic>>.from(results[5]),
              'preview_usefulness':
                  List<Map<String, dynamic>>.from(results[6]),
              'fsrs_usefulness':
                  List<Map<String, dynamic>>.from(results[7]),
              'ugc_perception':
                  List<Map<String, dynamic>>.from(results[8]),
              'sus': List<Map<String, dynamic>>.from(results[9]),
            };
          });

  Future<void> insertResearchUser(Map<String, dynamic> data) =>
      guard(() => client.from('research_users').insert(data));
}
