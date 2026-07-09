import 'package:boo_mondai/lib.barrel.dart'
    show
        CardSessionStep,
        CardTemplate,
        ConditionalMessageRule,
        Controller,
        LocalDB,
        MessageSessionStep,
        SessionException,
        SessionFlowCommand,
        SessionMode,
        SessionStep,
        StudyCard,
        StudyRating,
        StudySessionCoordinator,
        StudySessionEngine,
        StudySessionLocalStore,
        StudySessionRuleContext,
        StudySessionRuleRegistry,
        StudySessionRuntime,
        uuid;
import 'package:flutter/material.dart' show protected;

abstract class StudySessionController<VSession> extends Controller {
  StudySessionController() {
    _coordinator = StudySessionCoordinator(
      engine: StudySessionEngine(idFactory: uuid.v7),
      store: StudySessionLocalStore(
        flows: LocalDB.studySessionFlow,
        records: LocalDB.studySessionStepRecord,
      ),
      rules: StudySessionRuleRegistry([
        ConditionalMessageRule(
          id: 'three-incorrect-v1',
          when: (context) => context.consecutiveIncorrectAnswers == 3,
          occurrenceKey: (context) => 'after-step:${context.currentStepId}',
          buildMessage: (context) => MessageSessionStep(
            id: uuid.v7(),
            messageDefinitionId: 'slow-down',
            title: 'Take your time',
            message:
                'Read each prompt carefully. Accuracy matters more than speed.',
            insertedByRuleId: 'three-incorrect-v1',
            insertionReason: 'Three consecutive incorrect answers',
          ),
        ),
        ConditionalMessageRule(
          id: 'progress-encouragement-v1',
          when: (context) =>
              const {5, 10, 20}.contains(context.completedCardCount),
          occurrenceKey: (context) => 'completed:${context.completedCardCount}',
          buildMessage: (context) => MessageSessionStep(
            id: uuid.v7(),
            messageDefinitionId: 'progress-milestone',
            title: 'Good progress',
            message: '${context.completedCardCount} cards completed.',
            insertedByRuleId: 'progress-encouragement-v1',
            insertionReason:
                'Completed ${context.completedCardCount} card steps',
          ),
        ),
      ]),
    );
  }

  late final StudySessionCoordinator _coordinator;
  StudySessionRuntime? runtime;
  VSession? session;
  Map<String, CardTemplate> templates = {};
  Map<StudyRating, String> nextIntervals = {};

  SessionMode get mode;
  StudyCard? get currentStudyCard;
  List<StudyRating> get submittedRatings;

  SessionStep? get currentStep => runtime?.currentStep;
  CardSessionStep? get currentCardStep =>
      currentStep is CardSessionStep ? currentStep as CardSessionStep : null;
  int get currentIndex => runtime?.currentStepIndex ?? 0;
  int get totalStepCount => runtime?.snapshot.steps.length ?? 0;
  bool get isComplete => runtime?.isComplete ?? false;

  CardTemplate? get currentTemplate {
    final card = currentStudyCard;
    return card == null ? null : templates[card.templateId];
  }

  double getProgressPercentage() => runtime?.cardProgress ?? 0;

  Future<void> createFlow({
    required String sessionId,
    required List<StudyCard> cards,
    required DateTime now,
  }) async {
    runtime = await _coordinator.start(
      sessionId: sessionId,
      steps: [
        for (final card in cards)
          CardSessionStep(id: uuid.v7(), studyCardId: card.id),
      ],
      now: now,
    );
  }

  bool restoreFlow(String sessionId) {
    runtime = _coordinator.resume(sessionId);
    return runtime != null;
  }

  Future<void> beginSubmission(
    String userAnswer,
    StudyRating rating,
    DateTime now,
  ) async {
    final activeRuntime = runtime;
    if (activeRuntime == null) {
      failSession('Session flow is missing.', code: 'SESSION_FLOW_MISSING');
    }
    runtime = await _coordinator.beginSubmission(
      activeRuntime,
      userAnswer: userAnswer,
      rating: rating,
      now: now,
    );
  }

  Future<void> finishSubmission({
    required StudyRating rating,
    required DateTime startedAt,
    required Iterable<SessionFlowCommand> policyCommands,
    required DateTime now,
  }) async {
    final activeRuntime = runtime;
    final activeSession = session;
    final activeStep = currentCardStep;
    if (activeRuntime == null || activeSession == null || activeStep == null) {
      failSession(
        'Cannot finish an incomplete session transition.',
        code: 'SESSION_TRANSITION_INVALID',
      );
    }

    final ratings = [...submittedRatings, rating];
    final incorrect = ratings.reversed
        .takeWhile(
          (value) =>
              value == StudyRating.incorrect || value == StudyRating.again,
        )
        .length;
    final correct = ratings.where(
      (value) => value != StudyRating.incorrect && value != StudyRating.again,
    );
    final context = StudySessionRuleContext(
      sessionId: activeRuntime.snapshot.sessionId,
      currentStepId: activeStep.id,
      mode: mode,
      latestRating: rating,
      consecutiveCorrectAnswers: ratings.reversed
          .takeWhile(
            (value) =>
                value != StudyRating.incorrect && value != StudyRating.again,
          )
          .length,
      consecutiveIncorrectAnswers: incorrect,
      completedCardCount: activeRuntime.completedCardCount + 1,
      remainingCardCount:
          activeRuntime.snapshot.steps.whereType<CardSessionStep>().length -
          activeRuntime.completedCardCount -
          1,
      accuracy: ratings.isEmpty ? 0 : correct.length / ratings.length,
      elapsed: now.difference(startedAt),
      firedRuleKeys: activeRuntime.snapshot.firedRuleKeys,
    );
    runtime = await _coordinator.finishSubmission(
      activeRuntime,
      policyCommands: policyCommands,
      ruleContext: context,
      now: now,
    );
  }

  Future<void> advancePresentationStep() async {
    final activeRuntime = runtime;
    if (activeRuntime == null) return;
    runtime = await _coordinator.advancePresentationStep(
      activeRuntime,
      DateTime.now(),
    );
    if (isComplete) await completeSession();
    notifyListeners();
  }

  Never failSession(String message, {required String code}) {
    final exception = SessionException(message, code: code);
    setError(exception);
    throw exception;
  }

  Future<void> submitAnswer(String userAnswer, StudyRating type);
  Future<void> calculateNextIntervals();

  @protected
  Future<void> completeSession();

  void reset();
}
