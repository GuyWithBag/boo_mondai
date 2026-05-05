// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_streak_service.dart
// PURPOSE: Supabase sync for user streaks
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'supabase_service.dart';

class SupabaseStreakService extends SupabaseService {
  /// Fetches the streak row for [userId], remapping snake_case DB columns
  /// to the camelCase keys expected by [StreakMapper.fromMap].
  Future<Map<String, dynamic>?> fetchStreak(String userId) => guard(() async {
    final row = await client
        .from('streaks')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    return row == null ? null : _toCamelCase(row);
  });

  /// Upserts a streak row. [data] must use snake_case keys matching the DB
  /// schema (user_id, current_streak, longest_streak, last_activity_date).
  Future<void> upsertStreak(Map<String, dynamic> data) =>
      upsertRow('streaks', data, onConflict: 'user_id');

  // ── Private ───────────────────────────────────────────

  /// streaks columns → Dart field names
  ///   id                 → id
  ///   user_id            → userId
  ///   current_streak     → currentStreak
  ///   longest_streak     → longestStreak
  ///   last_activity_date → lastActivityDate
  Map<String, dynamic> _toCamelCase(Map<String, dynamic> row) => {
    'id': row['id'],
    'userId': row['user_id'],
    'currentStreak': row['current_streak'] ?? 0,
    'longestStreak': row['longest_streak'] ?? 0,
    'lastActivityDate': row['last_activity_date'],
  };
}
