// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/quiz_answer.dart
// PURPOSE: Individual answer within a quiz session
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class QuizAnswer {
  final String id;
  final String sessionId;
  final String cardId;
  final String userAnswer;
  final bool isCorrect;
  final int? selfRating; // 1=Again, 2=Hard, 3=Good, 4=Easy
  final DateTime answeredAt;

  const QuizAnswer({
    required this.id,
    required this.sessionId,
    required this.cardId,
    required this.userAnswer,
    required this.isCorrect,
    this.selfRating,
    required this.answeredAt,
  });

  factory QuizAnswer.fromJson(Map<String, dynamic> json) => QuizAnswer(
        id: json['id'] as String,
        sessionId: json['session_id'] as String,
        cardId: json['card_id'] as String,
        userAnswer: json['user_answer'] as String,
        isCorrect: json['is_correct'] as bool,
        selfRating: json['self_rating'] as int?,
        answeredAt: DateTime.parse(json['answered_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'session_id': sessionId,
        'card_id': cardId,
        'user_answer': userAnswer,
        'is_correct': isCorrect,
        'self_rating': selfRating,
        'answered_at': answeredAt.toIso8601String(),
      };

  QuizAnswer copyWith({
    String? id,
    String? sessionId,
    String? cardId,
    String? userAnswer,
    bool? isCorrect,
    int? selfRating,
    DateTime? answeredAt,
  }) =>
      QuizAnswer(
        id: id ?? this.id,
        sessionId: sessionId ?? this.sessionId,
        cardId: cardId ?? this.cardId,
        userAnswer: userAnswer ?? this.userAnswer,
        isCorrect: isCorrect ?? this.isCorrect,
        selfRating: selfRating ?? this.selfRating,
        answeredAt: answeredAt ?? this.answeredAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuizAnswer &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'QuizAnswer(id: $id, isCorrect: $isCorrect, selfRating: $selfRating)';
}
