import 'package:boo_mondai/lib.barrel.dart'
    show
        CardSessionStep,
        DrillAnswer,
        DrillSession,
        DrillStudySessionHelper,
        FsrsCard,
        FsrsHelper,
        LocalDB,
        RequeueCard,
        Services,
        SessionFlowCommand,
        StudyCard,
        StudyRating,
        StudySessionStepRecord;

final class DrillStepOutcome {
  const DrillStepOutcome({required this.answer, required this.commands});

  final DrillAnswer answer;
  final List<SessionFlowCommand> commands;
}

abstract final class DrillSessionPolicy {
  static List<StudyCard> selectCards({
    required String deckId,
    required String profileId,
    required int limit,
  }) {
    return (DrillStudySessionHelper.getEligibleDrillCards(
      deckId,
      profileId,
    )..shuffle()).take(limit).toList();
  }

  static Future<DrillStepOutcome> processSubmission({
    required DrillSession session,
    required CardSessionStep step,
    required StudyCard card,
    required String userAnswer,
    required StudyRating rating,
    required int sequenceNumber,
    required DateTime now,
  }) async {
    final existingRecord = LocalDB.studySessionStepRecord.getByStepId(
      session.id,
      step.id,
    );
    final existingAnswer = LocalDB.drillAnswer.selectByPk({'id': step.id});
    if (existingRecord != null && existingAnswer != null) {
      return DrillStepOutcome(
        answer: existingAnswer,
        commands: rating == StudyRating.incorrect || rating == StudyRating.again
            ? [
                RequeueCard(
                  studyCardId: card.id,
                  reason: 'Incorrect drill answer',
                ),
              ]
            : const [],
      );
    }

    final answer = DrillAnswer(
      id: step.id,
      sessionId: session.id,
      cardId: card.id,
      userAnswer: userAnswer,
      type: rating,
      createdAt: now,
    );
    await LocalDB.drillAnswer.upsert(answer);
    if (rating != StudyRating.incorrect && rating != StudyRating.again) {
      if (LocalDB.fsrsCard.getByStudyCardId(card.id) == null) {
        final fsrsCard = await FsrsCard.create(
          studyCardId: card.id,
          profileId: session.profileId,
        );
        await Services.fsrs.enrollCard(
          card: fsrsCard,
          rating: FsrsHelper.studyRatingToFSRSRating(rating),
        );
      }
    }
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
        drillAnswerId: answer.id,
      ),
    );

    return DrillStepOutcome(
      answer: answer,
      commands: rating == StudyRating.incorrect || rating == StudyRating.again
          ? [
              RequeueCard(
                studyCardId: card.id,
                reason: 'Incorrect drill answer',
              ),
            ]
          : const [],
    );
  }
}
