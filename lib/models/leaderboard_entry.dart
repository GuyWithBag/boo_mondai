// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/leaderboard_entry.dart
// PURPOSE: Leaderboard row from the Supabase leaderboard view
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class LeaderboardEntry {
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

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      LeaderboardEntry(
        userId: json['user_id'] as String,
        userName: json['display_name'] as String,
        targetLanguage: json['target_language'] as String?,
        quizScore: json['quiz_score'] as int? ?? 0,
        reviewCount: json['review_count'] as int? ?? 0,
        currentStreak: json['current_streak'] as int? ?? 0,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeaderboardEntry &&
          runtimeType == other.runtimeType &&
          userId == other.userId;

  @override
  int get hashCode => userId.hashCode;

  @override
  String toString() =>
      'LeaderboardEntry(userId: $userId, userName: $userName, quizScore: $quizScore)';
}
