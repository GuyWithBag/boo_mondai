// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/leaderboard_entry.dart
// PURPOSE: Leaderboard row from the Supabase leaderboard view
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/features/profile/models/cached_profile.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'leaderboard_entry.dto.mapper.dart';

@MappableClass()
class LeaderboardEntry with LeaderboardEntryMappable {
  final String userId;
  final int drillScore;
  final int reviewCount;
  final CachedProfile? userProfile;

  const LeaderboardEntry({
    required this.userId,
    required this.drillScore,
    required this.reviewCount,
    this.userProfile,
  });
}
