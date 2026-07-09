import 'package:boo_mondai/features/study_session/engine/session_flow.command.dart';
import 'package:boo_mondai/features/study_session/engine/study_session.engine.dart';
import 'package:boo_mondai/features/study_session/models/session_flow_snapshot.dto.dart';
import 'package:boo_mondai/features/study_session/models/session_step.dto.dart';
import 'package:boo_mondai/features/study_session/models/study_rating.dto.dart';
import 'package:boo_mondai/features/study_session/rules/conditional_message.rule.dart';
import 'package:boo_mondai/features/study_session/rules/study_session_rule.context.dart';
import 'package:boo_mondai/features/study_session/session_mode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late int nextId;
  late StudySessionEngine engine;
  final now = DateTime.utc(2026, 7, 9);

  setUp(() {
    nextId = 0;
    engine = StudySessionEngine(idFactory: () => 'generated-${nextId++}');
  });

  test('creates and advances an ordered flow', () {
    final runtime = engine.create(
      sessionId: 'session',
      steps: const [
        CardSessionStep(id: 'card-1', studyCardId: 'study-card-1'),
        MessageSessionStep(
          id: 'message',
          messageDefinitionId: 'encouragement',
          title: 'Keep going',
          message: 'You are making progress.',
        ),
        SummarySessionStep(id: 'summary'),
      ],
      now: now,
    );

    expect(runtime.currentStep?.id, 'card-1');
    expect(engine.advance(runtime, now).currentStep?.id, 'message');
  });

  test('inserts a dynamic step once per occurrence key', () {
    var runtime = engine.create(
      sessionId: 'session',
      steps: const [
        CardSessionStep(id: 'card-1', studyCardId: 'study-card-1'),
        CardSessionStep(id: 'card-2', studyCardId: 'study-card-2'),
      ],
      now: now,
    );
    const command = InsertAfterCurrent(
      occurrenceKey: 'rule:card-1',
      step: MessageSessionStep(
        id: 'message',
        messageDefinitionId: 'slow-down',
        title: 'Take your time',
        message: 'Accuracy matters more than speed.',
      ),
    );

    runtime = engine.applyCommands(runtime, const [command], now);
    runtime = engine.applyCommands(runtime, const [command], now);

    expect(runtime.snapshot.steps.map((step) => step.id), [
      'card-1',
      'message',
      'card-2',
    ]);
    expect(runtime.snapshot.firedRuleKeys, contains('rule:card-1'));
  });

  test('requeues a card as a new attempt with a new identity', () {
    final runtime = engine.create(
      sessionId: 'session',
      steps: const [CardSessionStep(id: 'card-1', studyCardId: 'study-card-1')],
      now: now,
    );

    final updated = engine.applyCommands(runtime, const [
      RequeueCard(studyCardId: 'study-card-1', reason: 'Incorrect answer'),
    ], now);
    final retry = updated.snapshot.steps.last as CardSessionStep;

    expect(retry.id, 'generated-0');
    expect(retry.attemptNumber, 2);
    expect(retry.insertionReason, 'Incorrect answer');
  });

  test('only card steps accept pending submissions', () {
    final runtime = engine.create(
      sessionId: 'session',
      steps: const [
        MessageSessionStep(
          id: 'message',
          messageDefinitionId: 'intro',
          title: 'Ready?',
          message: 'Start when ready.',
        ),
      ],
      now: now,
    );

    expect(
      () => engine.setPendingSubmission(
        runtime,
        PendingStepSubmission(
          stepId: 'message',
          userAnswer: '',
          rating: StudyRating.good,
          submittedAt: now,
        ),
        now,
      ),
      throwsStateError,
    );
  });

  test('conditional message rules preserve their reason and occurrence', () {
    final rule = ConditionalMessageRule(
      id: 'three-incorrect-v1',
      when: (context) => context.consecutiveIncorrectAnswers >= 3,
      occurrenceKey: (context) => 'after-step:${context.currentStepId}',
      buildMessage: (context) => MessageSessionStep(
        id: 'encouragement',
        messageDefinitionId: 'slow-down',
        title: 'Take your time',
        message: 'Accuracy matters more than speed.',
        insertedByRuleId: 'three-incorrect-v1',
        insertionReason: '${context.consecutiveIncorrectAnswers} incorrect',
      ),
    );
    const context = StudySessionRuleContext(
      sessionId: 'session',
      currentStepId: 'card-1',
      mode: SessionMode.drill,
      latestRating: StudyRating.incorrect,
      consecutiveCorrectAnswers: 0,
      consecutiveIncorrectAnswers: 3,
      completedCardCount: 3,
      remainingCardCount: 7,
      accuracy: 0,
      elapsed: Duration(minutes: 2),
      firedRuleKeys: {},
    );

    final command = rule.evaluate(context).single as InsertAfterCurrent;
    final step = command.step as MessageSessionStep;

    expect(command.occurrenceKey, 'three-incorrect-v1:after-step:card-1');
    expect(step.insertedByRuleId, rule.id);
    expect(step.insertionReason, '3 incorrect');
  });
}
