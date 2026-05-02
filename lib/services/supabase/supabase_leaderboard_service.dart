// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_leaderboard_service.dart
// PURPOSE: Supabase operations for the leaderboard view
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'supabase_service.dart';

class SupabaseLeaderboardService extends SupabaseService {
  /// Fetches the leaderboard view, optionally filtered by [targetLanguage].
  ///
  /// Supabase returns snake_case column names; this method converts them to the
  /// camelCase keys that [LeaderboardEntryMapper.fromMap] expects.
  Future<List<Map<String, dynamic>>> fetchLeaderboard({
    String? targetLanguage,
  }) => guard(() async {
    var query = client.from('leaderboard').select();
    if (targetLanguage != null) {
      // DB column is target_language (snake_case)
      query = query.eq('target_language', targetLanguage);
    }
    // DB column is drill_score (snake_case)
    final response = await query.order('drill_score', ascending: false);
    return List<Map<String, dynamic>>.from(
      response,
    ).map(_toLeaderboardCamelCase).toList();
  });

  /// Renames Supabase snake_case leaderboard columns to the camelCase field
  /// names expected by [LeaderboardEntryMapper].
  ///
  /// Leaderboard view columns → Dart field names:
  ///   user_id        → userId
  ///   display_name   → userName
  ///   target_language→ targetLanguage
  ///   drill_score    → drillScore
  ///   review_count   → reviewCount
  ///   current_streak → currentStreak
  Map<String, dynamic> _toLeaderboardCamelCase(Map<String, dynamic> row) => {
    'userId': row['user_id'],
    'userName': row['display_name'],
    'targetLanguage': row['target_language'],
    'drillScore': row['drill_score'] ?? 0,
    'reviewCount': row['review_count'] ?? 0,
    'currentStreak': row['current_streak'] ?? 0,
  };
}
