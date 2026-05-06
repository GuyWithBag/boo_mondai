// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/leaderboard_entry.dart
// PURPOSE: Leaderboard row from the Supabase leaderboard view
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dart_mappable/dart_mappable.dart';

part 'leaderboard_entry.dto.mapper.dart';

@MappableClass()
class LeaderboardEntry with LeaderboardEntryMappable {
  final String userId;
  final int drillScore;
  final int reviewCount;

  const LeaderboardEntry({
    required this.userId,
    required this.drillScore,
    required this.reviewCount,
  });
}
