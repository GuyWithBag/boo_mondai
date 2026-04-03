// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/user_deck_progress.dart
// PURPOSE: Tracks a specific user's progress through a specific deck
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
import 'package:dart_mappable/dart_mappable.dart';

part 'user_deck_progress.mapper.dart';

@MappableClass()
class UserDeckProgress with UserDeckProgressMappable {
  final String id;
  final String userId;
  final String deckId;

  // Cached stats for fast UI rendering
  final int newCardsCount;
  final int learningCardsCount;
  final int reviewCardsCount;
  final int totalQuizzed; // Total cards ever seen/enrolled

  final DateTime lastStudiedAt;

  const UserDeckProgress({
    required this.id,
    required this.userId,
    required this.deckId,
    this.newCardsCount = 0,
    this.learningCardsCount = 0,
    this.reviewCardsCount = 0,
    this.totalQuizzed = 0,
    required this.lastStudiedAt,
  });

  /// True if the user has started studying this deck
  bool get hasStartedQuizzing => totalQuizzed > 0;
}
