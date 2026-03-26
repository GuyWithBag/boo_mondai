// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/quiz_session.dart
// PURPOSE: Represents a single quiz session on a deck
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class QuizSession {
  final String id;
  final String userId;
  final String deckId;
  final bool previewed;
  final int totalQuestions;
  final int correctCount;
  final DateTime startedAt;
  final DateTime? completedAt;

  const QuizSession({
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

  factory QuizSession.fromJson(Map<String, dynamic> json) => QuizSession(
        id: json['id'] as String,
        userId: json['user_id'] as String,
        deckId: json['deck_id'] as String,
        previewed: json['previewed'] as bool? ?? false,
        totalQuestions: json['total_questions'] as int,
        correctCount: json['correct_count'] as int? ?? 0,
        startedAt: DateTime.parse(json['started_at'] as String),
        completedAt: json['completed_at'] != null
            ? DateTime.parse(json['completed_at'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'deck_id': deckId,
        'previewed': previewed,
        'total_questions': totalQuestions,
        'correct_count': correctCount,
        'started_at': startedAt.toIso8601String(),
        'completed_at': completedAt?.toIso8601String(),
      };

  QuizSession copyWith({
    String? id,
    String? userId,
    String? deckId,
    bool? previewed,
    int? totalQuestions,
    int? correctCount,
    DateTime? startedAt,
    DateTime? completedAt,
  }) =>
      QuizSession(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        deckId: deckId ?? this.deckId,
        previewed: previewed ?? this.previewed,
        totalQuestions: totalQuestions ?? this.totalQuestions,
        correctCount: correctCount ?? this.correctCount,
        startedAt: startedAt ?? this.startedAt,
        completedAt: completedAt ?? this.completedAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizSession &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'QuizSession(id: $id, correctCount: $correctCount/$totalQuestions)';
}
