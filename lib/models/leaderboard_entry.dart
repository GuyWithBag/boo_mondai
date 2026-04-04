// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/leaderboard_entry.dart
// PURPOSE: Leaderboard row from the Supabase leaderboard view
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dart_mappable/dart_mappable.dart';

part 'leaderboard_entry.mapper.dart';

@MappableClass()
class LeaderboardEntry with LeaderboardEntryMappable {
  final String userId;
  final String userName;
  final String? targetLanguage;
  final int quizScore;
  final int reviewCount;
  final int currentStreak;

  const LeaderboardEntry({
    required this.userId,
    required this.userName,
    this.targetLanguage,
    required this.quizScore,
    required this.reviewCount,
    required this.currentStreak,
  });
}
