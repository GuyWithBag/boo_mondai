import 'package:boo_mondai/lib.barrel.dart'
    show
        CardSessionStep,
        FsrsCard,
        FsrsHelper,
        FsrsReviewLog,
        LocalDB,
        RequeueCard,
        ReviewSession,
        SessionFlowCommand,
        StudyCard,
        StudyRating,
        StudySessionStepRecord;
import 'package:fsrs/fsrs.dart' as fsrs;

final class ReviewStepOutcome {
  const ReviewStepOutcome({
    required this.updatedCard,
    required this.log,
    required this.commands,
  });

  final FsrsCard updatedCard;
  final FsrsReviewLog log;
  final List<SessionFlowCommand> commands;
}

abstract final class ReviewSessionPolicy {
  static Future<ReviewStepOutcome> processSubmission({
    required ReviewSession session,
    required CardSessionStep step,
    required StudyCard card,
    required FsrsCard fsrsCard,
    required String userAnswer,
    required StudyRating rating,
    required int sequenceNumber,
    required DateTime now,
  }) async {
    final existingRecord = LocalDB.studySessionStepRecord.getByStepId(
      session.id,
      step.id,
    );
    final existingLog = LocalDB.reviewLog.selectByPk({'id': step.id});
    if (existingRecord != null && existingLog != null) {
      return ReviewStepOutcome(
        updatedCard: LocalDB.fsrsCard.getByStudyCardId(card.id) ?? fsrsCard,
        log: existingLog,
        commands: rating == StudyRating.incorrect || rating == StudyRating.again
            ? [
                RequeueCard(
                  studyCardId: card.id,
                  reason: 'Failed review answer',
                ),
              ]
            : const [],
      );
    }

    final reviewTime = fsrsCard.state.due.isAfter(now)
        ? fsrsCard.state.due
        : now;
    final result = fsrs.Scheduler().reviewCard(
      fsrsCard.state,
      FsrsHelper.studyRatingToFSRSRating(rating),
      reviewDateTime: reviewTime.toUtc(),
    );
    final updatedCard = fsrsCard.copyWith(state: result.card);
    final log = FsrsReviewLog(
      id: step.id,
      createdAt: now,
      fsrsCardId: fsrsCard.id,
      log: result.reviewLog,
    );
    await LocalDB.fsrsCard.upsert(updatedCard);
    await LocalDB.reviewLog.upsert(log);
    await LocalDB.studySessionStepRecord.upsert(
      StudySessionStepRecord(
        id: step.id,
        sessionId: session.id,
        stepId: step.id,
        studyCardId: card.id,
        sequenceNumber: sequenceNumber,
        attemptNumber: step.attemptNumber,
        userAnswer: userAnswer,
        rating: rating,
        enteredAt: now,
        completedAt: now,
        fsrsReviewLogId: log.id,
      ),
    );

    return ReviewStepOutcome(
      updatedCard: updatedCard,
      log: log,
      commands: rating == StudyRating.incorrect || rating == StudyRating.again
          ? [RequeueCard(studyCardId: card.id, reason: 'Failed review answer')]
          : const [],
    );
  }
}
