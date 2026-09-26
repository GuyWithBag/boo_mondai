// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/supabase_leaderboard_service.dart
// PURPOSE: Supabase operations for the leaderboard view
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        SupabaseRemoteDB,
        LeaderboardEntry,
        LeaderboardEntryMapper,
        Profile,
        ProfileMapper;

typedef JoinedLeaderboardEntry = ({LeaderboardEntry entry, Profile profile});

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
    'profile_id': item.profileId,
  };

  Future<List<JoinedLeaderboardEntry>> selectJoined() async {
    final res = await query
        .select('*, profiles!inner(displayName, avatarUrl)')
        .limit(5);
    final typed = res
        .map(
          (value) => (
            entry: LeaderboardEntryMapper.fromMap(value),
            profile: ProfileMapper.fromMap(value['profiles']),
          ),
        )
        .toList();

    return typed;
  }
}
