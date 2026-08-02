// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/streak.dart
// PURPOSE: User streak data — tracks daily FSRS review activity
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show MutableEntity, MutableEntityCopyWith, MutableEntityMapper;
import 'package:dart_mappable/dart_mappable.dart';

part 'streak.dto.mapper.dart';

@MappableClass()
class Streak with StreakMappable implements MutableEntity {
  final String id;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final DateTime? deletedAt;
  @override
  final DateTime? purgeAfter;
  final String profileId;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastActivityDate;

  const Streak({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.purgeAfter,
    required this.profileId,
    required this.currentStreak,
    required this.longestStreak,
    this.lastActivityDate,
  });
}
