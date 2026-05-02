// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_streak_service.dart
// PURPOSE: Supabase sync for user streaks
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'supabase_service.dart';

class SupabaseStreakService extends SupabaseService {
  /// Fetches the streak row for [userId].
  ///
  /// Converts snake_case Supabase columns to the camelCase keys that
  /// [StreakMapper.fromMap] expects before returning.
  Future<Map<String, dynamic>?> fetchStreak(String userId) => guard(() async {
    final row = await client
        .from('streaks')
        .select()
        .eq('user_id', userId) // DB column: user_id
        .maybeSingle();
    if (row == null) return null;
    return _toStreakCamelCase(row);
  });

  /// Upserts a streak row. [data] must use snake_case keys matching the DB
  /// schema (user_id, current_streak, longest_streak, last_activity_date).
  Future<void> upsertStreak(Map<String, dynamic> data) =>
      guard(() => client.from('streaks').upsert(data, onConflict: 'user_id'));

  /// Renames Supabase snake_case streak columns to the camelCase field names
  /// expected by [StreakMapper].
  ///
  /// streaks table columns → Dart field names:
  ///   id                 → id
  ///   user_id            → userId
  ///   current_streak     → currentStreak
  ///   longest_streak     → longestStreak
  ///   last_activity_date → lastActivityDate
  Map<String, dynamic> _toStreakCamelCase(Map<String, dynamic> row) => {
    'id': row['id'],
    'userId': row['user_id'],
    'currentStreak': row['current_streak'] ?? 0,
    'longestStreak': row['longest_streak'] ?? 0,
    'lastActivityDate': row['last_activity_date'],
  };
}
