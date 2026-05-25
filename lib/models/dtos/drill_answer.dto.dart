// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/models/drill_answer.dart
// PURPOSE: Individual answer within a drill session
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/models/models.barrel.dart';
import 'package:boo_mondai/shared/uuid.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'drill_answer.dto.mapper.dart';

/// For showing to logs and showing the end results after a drill
@MappableClass()
class DrillAnswer with DrillAnswerMappable implements WriteOnceDTO {
  @override
  final String id;
  final String sessionId;
  final String cardId;
  final String userAnswer;
  final StudyRating type;
  @override
  final DateTime createdAt;
  final DrillSession? session;
  final CardTemplate? cardTemplate;

  const DrillAnswer({
    required this.id,
    required this.sessionId,
    required this.cardId,
    required this.userAnswer,
    required this.type,
    required this.createdAt,
    this.session,
    this.cardTemplate,
  });

  factory DrillAnswer.create({
    required String sessionId,
    required String cardId,
    required String userAnswer,
    required StudyRating type,
  }) {
    final val = DrillAnswer(
      id: uuid.v7(),
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
}
