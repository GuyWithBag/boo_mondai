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
class DrillAnswer with DrillAnswerMappable {
  final String id;
  final String sessionId;
  final String cardId;
  final String userAnswer;
  final StudyRating type;
  final DateTime createdAt;

  const DrillAnswer({
    required this.id,
    required this.sessionId,
    required this.cardId,
    required this.userAnswer,
    required this.type,
    required this.createdAt,
  });

  factory DrillAnswer.create({
    required String sessionId,
    required String cardId,
    required String userAnswer,
    required StudyRating type,
  }) {
    final val = DrillAnswer(
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
    return type != StudyRating.incorrect;
  }

  static StudyRating fromRatingToType(Rating rating) {
    // FIX: Must include the 'Rating' enum name on every case
    switch (rating) {
      case Rating.again:
        return StudyRating.again;
      case Rating.hard:
        return StudyRating.hard;
      case Rating.good:
        return StudyRating.good;
      case Rating.easy:
        return StudyRating.easy;
    }
  }
}
