// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_leaderboard_service.dart
// PURPOSE: Supabase operations for the leaderboard view
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show SupabaseRemoteDB, LeaderboardEntry, LeaderboardEntryMapper;

class LeaderboardEntriesRemoteDB extends SupabaseRemoteDB<LeaderboardEntry> {
  @override
  String get tableName => 'leaderboard_entries';

  @override
  LeaderboardEntry Function(Map<String, dynamic>) get fromMap =>
      LeaderboardEntryMapper.fromMap;

  @override
  Map<String, dynamic> toMap(LeaderboardEntry item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(LeaderboardEntry item) => {
    'user_id': item.userId,
  };

  @override
  String get defaultSelect => _leaderboardEntryWithRelationsSelect;

  @override
  Set<String> get joinedFields => const {'userProfile', 'user_profile'};

  /// The view's display_name column is aliased to user_name to match the
  /// key expected by [LeaderboardEntryMapper].
  Future<List<LeaderboardEntry>> fetchLeaderboard() => guard(() async {
    final query = client
        .from(tableName)
        .select(_leaderboardEntryWithRelationsSelect);
    final response = await query.order('drill_score', ascending: false);
    return List<Map<String, dynamic>>.from(
      response,
    ).map(fromJoinedMap).toList();
  }, action: 'fetchLeaderboard()');
}

const _leaderboardEntryWithRelationsSelect =
    'user_id, drill_score, review_count, user_profile';
