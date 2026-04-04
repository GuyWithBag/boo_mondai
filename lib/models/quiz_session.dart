// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/quiz_session.dart
// PURPOSE: Represents a single quiz session on a deck
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:dart_mappable/dart_mappable.dart';

part 'quiz_session.mapper.dart';

@MappableClass()
class DrillSession with DrillSessionMappable {
  final String id;
  final String userId;
  final String deckId;
  final bool previewed;
  final int totalQuestions;
  final int correctCount;
  final DateTime startedAt;
  final DateTime? completedAt;

  const DrillSession({
    required this.id,
    required this.userId,
    required this.deckId,
    required this.previewed,
    required this.totalQuestions,
    required this.correctCount,
    required this.startedAt,
    this.completedAt,
  });

  bool get isComplete => completedAt != null;

  double get scorePercent =>
      totalQuestions > 0 ? correctCount / totalQuestions : 0;
}
