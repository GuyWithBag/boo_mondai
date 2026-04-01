// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_leaderboard_service.dart
// PURPOSE: Supabase operations for leaderboard and streaks
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'supabase_service.dart';

class SupabaseLeaderboardService extends SupabaseService {
  Future<List<Map<String, dynamic>>> fetchLeaderboard({
    String? targetLanguage,
  }) =>
      guard(() async {
        var query = client.from('leaderboard').select();
        if (targetLanguage != null) {
          query = query.eq('target_language', targetLanguage);
        }
        final response =
            await query.order('quiz_score', ascending: false);
        return List<Map<String, dynamic>>.from(response);
      });

  Future<void> upsertStreak(Map<String, dynamic> data) =>
      guard(() => client.from('streaks').upsert(data));

  Future<Map<String, dynamic>?> fetchStreak(String userId) =>
      guard(() => client
          .from('streaks')
          .select()
          .eq('user_id', userId)
          .maybeSingle());
}
