# Study Session Extension Quick Start

This guide shows how to add steps, insertion conditions, and mode behavior
without putting domain logic back into widgets or controllers.

Read [architecture.md](architecture.md) before changing persistence or session
lifecycle behavior.

## Add a presentation step

Create a serializable step subtype:

```dart
@MappableClass(discriminatorValue: 'message')
final class MessageSessionStep extends SessionStepSnapshot
    with MessageSessionStepMappable {
  final String messageDefinitionId;
  final String? resolvedTitle;
  final String? resolvedMessage;

  const MessageSessionStep({
    required super.id,
    required this.messageDefinitionId,
    this.resolvedTitle,
    this.resolvedMessage,
    super.insertedByRuleId,
    super.insertionReason,
  });
}
```

Add a renderer:

```dart
Widget buildCurrentStep(SessionStepSnapshot step) {
  return switch (step) {
    CardSessionStep step => StudyCardStepPage(step: step),
    MessageSessionStep step => StudySessionMessagePage(
      title: step.resolvedTitle,
      message: step.resolvedMessage,
      onContinue: controller.advancePresentationStep,
    ),
    SummarySessionStep step => StudySessionSummaryPage(step: step),
  };
}
```

Do not create a `StudySessionStepRecord` for this step. Advancing it only
updates `currentStepId` in the local flow snapshot.

## Add a dynamic condition

Implement `StudySessionInsertionRule`:

```dart
final class ThreeIncorrectAnswersRule
    implements StudySessionInsertionRule {
  @override
  String get id => 'three-incorrect-v1';

  @override
  List<SessionFlowCommand> evaluate(StudySessionRuleContext context) {
    if (context.consecutiveIncorrectAnswers != 3) {
      return const [];
    }

    final occurrenceKey = '$id:after-step:${context.currentStepId}';
    if (context.firedRuleKeys.contains(occurrenceKey)) {
      return const [];
    }

    return [
      InsertAfterCurrent(
        occurrenceKey: occurrenceKey,
        step: MessageSessionStep(
          id: uuid.v7(),
          messageDefinitionId: 'slow-down',
          resolvedTitle: 'Take your time',
          resolvedMessage:
              'Read each prompt carefully. Accuracy matters more than speed.',
          insertedByRuleId: id,
          insertionReason: 'Three consecutive incorrect answers',
        ),
      ),
    ];
  }
}
```

Register it:

```dart
final registry = StudySessionRuleRegistry([
  ThreeIncorrectAnswersRule(),
  ProgressEncouragementRule(),
]);
```

Rules should:

- Read facts only from `StudySessionRuleContext`.
- Return commands rather than editing lists.
- Include a stable rule ID.
- Include a unique occurrence key.
- Record a human-readable insertion reason.
- Avoid database, navigation, and widget dependencies.

## Add a progress encouragement

Use completed card counts, not the flow index:

```dart
final class ProgressEncouragementRule
    implements StudySessionInsertionRule {
  @override
  String get id => 'progress-encouragement-v1';

  @override
  List<SessionFlowCommand> evaluate(StudySessionRuleContext context) {
    const milestones = {5, 10, 20};
    if (!milestones.contains(context.completedCardCount)) {
      return const [];
    }

    final occurrenceKey = '$id:${context.completedCardCount}';
    if (context.firedRuleKeys.contains(occurrenceKey)) {
      return const [];
    }

    return [
      InsertAfterCurrent(
        occurrenceKey: occurrenceKey,
        step: MessageSessionStep(
          id: uuid.v7(),
          messageDefinitionId: 'progress-milestone',
          resolvedTitle: 'Good progress',
          resolvedMessage:
              '${context.completedCardCount} cards completed.',
          insertedByRuleId: id,
          insertionReason:
              'Completed ${context.completedCardCount} card steps',
        ),
      ),
    ];
  }
}
```

## Requeue a card

Requeueing is a mode-policy decision:

```dart
if (outcome.isIncorrect) {
  commands.add(
    RequeueCard(
      studyCardId: outcome.studyCardId,
      reason: 'Incorrect drill answer',
    ),
  );
}
```

The engine creates a new `CardSessionStep` with:

- A new step ID.
- The same study card ID.
- An incremented attempt number.
- The insertion reason.

Do not append the same step object. Each attempt needs its own identity so it
can create exactly one activity record.

## Add a new card-producing step

If the step produces learning data:

1. Add a `SessionStepSnapshot` subtype.
2. Add its renderer.
3. Add policy processing for its submission.
4. Add a `StudySessionStepRecord` subtype.
5. Add local persistence and a unique `(sessionId, stepId)` check.
6. Add resume and duplicate-submission tests.

Do not add a record type merely because a widget exists.

## Add a new session mode

Implement the shared policy contract:

```dart
final class ListeningSessionPolicy implements StudySessionPolicy {
  @override
  Future<List<SessionStepSnapshot>> buildInitialSteps(
    StudySessionStartRequest request,
  ) async {
    // Select local cards and return ordered step data.
  }

  @override
  Future<ProcessedStepOutcome> submitCard(
    CardSessionStep step,
    CardSubmission submission,
  ) async {
    // Grade, build records, and return flow commands.
  }

  @override
  StudySessionRuleContext buildRuleContext(
    StudySessionRuntime runtime,
    ProcessedStepOutcome outcome,
  ) {
    // Convert runtime facts into rule facts.
  }
}
```

The policy owns mode-specific decisions. The engine must not contain checks
such as:

```dart
if (mode == SessionMode.drill) {
  // ...
}
```

## Submit a card safely

Use the coordinator entry point:

```dart
await coordinator.submitCurrentCard(
  CardSubmission(
    userAnswer: answer,
    rating: rating,
  ),
);
```

The coordinator must:

1. Confirm the current step is a card.
2. Save a pending-submission marker.
3. Ask the mode policy to process the outcome.
4. Upsert the activity and mode-specific records.
5. Evaluate insertion rules.
6. Apply returned flow commands.
7. Advance the engine.
8. Persist the summary and flow snapshot.
9. Clear the pending marker.
10. Notify the controller.

Never perform these writes directly from a widget.

## Resume an unfinished session

```dart
final resumable = await store.findUnfinishedSession(
  profileId: profileId,
  mode: mode,
  deckId: deckId,
);

if (resumable != null) {
  final runtime = await coordinator.resume(resumable.id);
  controller.attach(runtime);
} else {
  final runtime = await coordinator.start(request);
  controller.attach(runtime);
}
```

On resume:

- Replay a pending submission idempotently.
- Restore `currentStepId`.
- Restore message content from the snapshot.
- Restart an incomplete card at its question stage.
- Skip card steps whose referenced local card no longer exists.

## Persistence checklist

For every new persisted DTO:

- Add `@MappableClass`.
- Add the mapper `part` declaration.
- Regenerate mappers and barrels.
- Register its Hive adapter if required by the current Hive setup.
- Add and initialize its local DB in `LocalDB`.
- Include it in local database clearing.
- Test serialization round trips.

Commands:

```sh
dart run build_runner build --delete-conflicting-outputs
dart format lib test
flutter analyze
flutter test
```

## Testing checklist

At minimum, test:

- Initial step ordering.
- Inserting after the current step.
- Requeueing creates a new step ID and attempt number.
- A rule occurrence cannot fire twice.
- Presentation steps do not create activity records.
- Card steps create exactly one record.
- Resume restores a dynamic message.
- Resume restarts an incomplete card at the question stage.
- A pending submission is replayed without duplicate records.
- Deleted cards are skipped safely.
- Completing a session clears pending state.

## Design guardrails

- Steps are data, not widgets.
- Conditions are named rules, not anonymous callbacks stored in DTOs.
- The engine owns ordering.
- Policies own learning-mode decisions.
- The coordinator owns orchestration.
- The local store owns persistence.
- Controllers own observable UI state only.
- Helpers remain small and stateless.
- Presentation steps are persisted for resume but excluded from learning
  history and scoring.
