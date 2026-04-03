// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/quiz_answer.dart
// PURPOSE: Individual answer within a quiz session
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/quiz_answer_type.dart';
import 'package:boo_mondai/services/services.barrel.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:fsrs/fsrs.dart';

part 'quiz_answer.mapper.dart';

@MappableClass()
class QuizAnswer with QuizAnswerMappable {
  final String id;
  final String sessionId;
  final String cardId;
  final String userAnswer;
  final QuizAnswerType type;
  final DateTime createdAt;

  const QuizAnswer({
    required this.id,
    required this.sessionId,
    required this.cardId,
    required this.userAnswer,
    required this.type,
    required this.createdAt,
  });

  factory QuizAnswer.create({
    required String sessionId,
    required String cardId,
    required String userAnswer,
    required QuizAnswerType type,
  }) {
    final val = QuizAnswer(
      id: UuidService.uuid.v4(),
      createdAt: DateTime.now(),
      sessionId: sessionId,
      type: type,
      userAnswer: userAnswer,
      cardId: cardId,
    );
    return val;
  }

  bool isCorrect() {
    // FIX: Must include the enum name
    return type != QuizAnswerType.incorrect;
  }

  static QuizAnswerType fromRatingToType(Rating rating) {
    // FIX: Must include the 'Rating' enum name on every case
    switch (rating) {
      case Rating.again:
        return QuizAnswerType.again;
      case Rating.hard:
        return QuizAnswerType.hard;
      case Rating.good:
        return QuizAnswerType.good;
      case Rating.easy:
        return QuizAnswerType.easy;
    }
  }
}
