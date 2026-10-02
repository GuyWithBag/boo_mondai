import 'package:boo_mondai/lib.barrel.dart'
    show
        CardTemplate,
        FsrsCard,
        FsrsReviewLog,
        SessionException,
        StudyCard,
        StudySessionAnswer,
        StudySessionCardStep,
        StudySessionMessageStep,
        StudySessionStep;
import 'package:boo_mondai/ui/study_session.card_stage/models/study_rating.dto.dart';

final class StudySessionSnapshot {
  const StudySessionSnapshot({
    required this.sessionId,
    required this.sequenceNumber,
    required this.step,
    required this.completedAt,
    this.studyCard,
    this.cardTemplate,
    this.fsrsCardBefore,
    this.fsrsCardAfter,
    this.fsrsReviewLog,
    this.answer,
    this.rating,
  });

  factory StudySessionSnapshot.card({
    required String sessionId,
    required int sequenceNumber,
    required StudySessionCardStep step,
    required StudyCard studyCard,
    required CardTemplate cardTemplate,
    required StudySessionAnswer answer,
    required StudyRating rating,
    required DateTime completedAt,
    FsrsCard? fsrsCardBefore,
    FsrsCard? fsrsCardAfter,
    FsrsReviewLog? fsrsReviewLog,
  }) {
    if (step.studyCardId != studyCard.id ||
        studyCard.templateId != cardTemplate.id) {
      throw SessionException(
        'Card step data does not match.',
        code: 'SESSION_CARD_MISMATCH',
      );
    }
    return StudySessionSnapshot(
      sessionId: sessionId,
      sequenceNumber: sequenceNumber,
      step: step,
      studyCard: studyCard,
      cardTemplate: cardTemplate,
      fsrsCardBefore: fsrsCardBefore,
      fsrsCardAfter: fsrsCardAfter,
      fsrsReviewLog: fsrsReviewLog,
      answer: answer,
      rating: rating,
      completedAt: completedAt,
    );
  }

  factory StudySessionSnapshot.message({
    required String sessionId,
    required int sequenceNumber,
    required StudySessionMessageStep step,
    required DateTime completedAt,
  }) => StudySessionSnapshot(
    sessionId: sessionId,
    sequenceNumber: sequenceNumber,
    step: step,
    completedAt: completedAt,
  );

  final String sessionId;
  final int sequenceNumber;
  final StudySessionStep step;
  final StudyCard? studyCard;
  final CardTemplate? cardTemplate;
  final FsrsCard? fsrsCardBefore;
  final FsrsCard? fsrsCardAfter;
  final FsrsReviewLog? fsrsReviewLog;
  final StudySessionAnswer? answer;
  final StudyRating? rating;
  final DateTime completedAt;
}
