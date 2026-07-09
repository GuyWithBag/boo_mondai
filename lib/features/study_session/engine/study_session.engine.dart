import 'package:boo_mondai/features/study_session/engine/session_flow.command.dart';
import 'package:boo_mondai/features/study_session/engine/study_session.runtime.dart';
import 'package:boo_mondai/features/study_session/models/session_flow_snapshot.dto.dart';
import 'package:boo_mondai/features/study_session/models/session_step.dto.dart';

typedef SessionStepIdFactory = String Function();

final class StudySessionEngine {
  const StudySessionEngine({required SessionStepIdFactory idFactory})
    : _idFactory = idFactory;

  final SessionStepIdFactory _idFactory;

  StudySessionRuntime create({
    required String sessionId,
    required List<SessionStep> steps,
    required DateTime now,
  }) {
    _validateUniqueStepIds(steps);
    return StudySessionRuntime(
      SessionFlowSnapshot(
        sessionId: sessionId,
        currentStepId: steps.firstOrNull?.id,
        steps: List.unmodifiable(steps),
        updatedAt: now,
      ),
    );
  }

  StudySessionRuntime restore(SessionFlowSnapshot snapshot) {
    _validateUniqueStepIds(snapshot.steps);
    final currentStepId = snapshot.currentStepId;
    if (currentStepId != null &&
        !snapshot.steps.any((step) => step.id == currentStepId)) {
      throw StateError(
        'Current step $currentStepId does not exist in session '
        '${snapshot.sessionId}.',
      );
    }
    return StudySessionRuntime(snapshot);
  }

  StudySessionRuntime advance(StudySessionRuntime runtime, DateTime now) {
    final index = runtime.currentStepIndex;
    if (index < 0) {
      throw StateError('Cannot advance an invalid session cursor.');
    }

    final nextStepId = index + 1 < runtime.snapshot.steps.length
        ? runtime.snapshot.steps[index + 1].id
        : null;
    return _copyRuntime(
      runtime,
      currentStepId: nextStepId,
      setCurrentStepId: true,
      now: now,
    );
  }

  StudySessionRuntime setPendingSubmission(
    StudySessionRuntime runtime,
    PendingStepSubmission submission,
    DateTime now,
  ) {
    if (runtime.currentStep?.id != submission.stepId) {
      throw StateError('A submission must target the current step.');
    }
    if (runtime.currentStep is! CardSessionStep) {
      throw StateError('Only card steps accept submissions.');
    }
    return _copyRuntime(
      runtime,
      pendingSubmission: submission,
      setPendingSubmission: true,
      now: now,
    );
  }

  StudySessionRuntime clearPendingSubmission(
    StudySessionRuntime runtime,
    DateTime now,
  ) {
    return _copyRuntime(runtime, setPendingSubmission: true, now: now);
  }

  StudySessionRuntime applyCommands(
    StudySessionRuntime runtime,
    Iterable<SessionFlowCommand> commands,
    DateTime now,
  ) {
    final steps = runtime.snapshot.steps.toList();
    final firedRuleKeys = runtime.snapshot.firedRuleKeys.toSet();
    var insertionOffset = 1;

    for (final command in commands) {
      final occurrenceKey = command.occurrenceKey;
      if (occurrenceKey != null && firedRuleKeys.contains(occurrenceKey)) {
        continue;
      }

      switch (command) {
        case InsertAfterCurrent(:final step):
          _ensureNewStepId(steps, step);
          final currentIndex = steps.indexWhere(
            (candidate) => candidate.id == runtime.snapshot.currentStepId,
          );
          if (currentIndex < 0) {
            throw StateError('Cannot insert after a missing current step.');
          }
          steps.insert(currentIndex + insertionOffset, step);
          insertionOffset++;
        case AppendSessionStep(:final step):
          _ensureNewStepId(steps, step);
          steps.add(step);
        case RequeueCard(:final studyCardId, :final reason):
          final attempts = steps
              .whereType<CardSessionStep>()
              .where((step) => step.studyCardId == studyCardId)
              .map((step) => step.attemptNumber);
          final attemptNumber = attempts.isEmpty
              ? 1
              : attempts.reduce((a, b) => a > b ? a : b) + 1;
          steps.add(
            CardSessionStep(
              id: _idFactory(),
              studyCardId: studyCardId,
              attemptNumber: attemptNumber,
              insertionReason: reason,
            ),
          );
      }

      if (occurrenceKey != null) {
        firedRuleKeys.add(occurrenceKey);
      }
    }

    return StudySessionRuntime(
      runtime.snapshot.copyWith(
        steps: List.unmodifiable(steps),
        firedRuleKeys: Set.unmodifiable(firedRuleKeys),
        updatedAt: now,
      ),
    );
  }

  StudySessionRuntime _copyRuntime(
    StudySessionRuntime runtime, {
    String? currentStepId,
    bool setCurrentStepId = false,
    PendingStepSubmission? pendingSubmission,
    bool setPendingSubmission = false,
    required DateTime now,
  }) {
    return StudySessionRuntime(
      runtime.snapshot.copyWith(
        currentStepId: setCurrentStepId
            ? currentStepId
            : runtime.snapshot.currentStepId,
        pendingSubmission: setPendingSubmission
            ? pendingSubmission
            : runtime.snapshot.pendingSubmission,
        updatedAt: now,
      ),
    );
  }

  void _validateUniqueStepIds(List<SessionStep> steps) {
    final ids = <String>{};
    for (final step in steps) {
      if (!ids.add(step.id)) {
        throw ArgumentError.value(step.id, 'steps', 'Duplicate step ID');
      }
    }
  }

  void _ensureNewStepId(List<SessionStep> steps, SessionStep step) {
    if (steps.any((candidate) => candidate.id == step.id)) {
      throw ArgumentError.value(step.id, 'step', 'Duplicate step ID');
    }
  }
}
