// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_leaderboard_service.dart
// PURPOSE: Supabase operations for the leaderboard view
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/database/database.barrel.dart';

class LeaderboardEntryRemoteDB extends SupabaseRemoteDB<LeaderboardEntry> {
  @override
  String get tableName => 'leaderboard';

  @override
  LeaderboardEntry Function(Map<String, dynamic>) get fromMap =>
      LeaderboardEntryMapper.fromMap;

  @override
  Map<String, dynamic> toMap(LeaderboardEntry item) => item.toMap();

  /// The view's display_name column is aliased to user_name to match the
  /// key expected by [LeaderboardEntryMapper].
  Future<List<LeaderboardEntry>> fetchLeaderboard() => guard(() async {
    var query = client
        .from(tableName)
        .select(
          'user_id, display_name as user_name, target_language, drill_score, review_count, current_streak',
        );
    final response = await query.order('drill_score', ascending: false);
    return List<Map<String, dynamic>>.from(response).map(fromMap).toList();
  });
}
