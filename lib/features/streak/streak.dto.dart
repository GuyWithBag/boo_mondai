// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/streak.dart
// PURPOSE: User streak data — tracks daily FSRS review activity
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/core/models/dto.dart' show DTO;
import 'package:dart_mappable/dart_mappable.dart';

part 'streak.dto.mapper.dart';

@MappableClass()
class Streak with StreakMappable implements DTO {
  @override
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  final String userId;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActivityDate;

  const Streak({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.currentStreak,
    required this.longestStreak,
    this.lastActivityDate,
  });
}
