import 'package:boo_mondai/features/study_session/engine/session_flow.command.dart';
import 'package:boo_mondai/features/study_session/engine/study_session.engine.dart';
import 'package:boo_mondai/features/study_session/engine/study_session.runtime.dart';
import 'package:boo_mondai/features/study_session/models/session_flow_snapshot.dto.dart';
import 'package:boo_mondai/features/study_session/models/session_step.dto.dart';
import 'package:boo_mondai/features/study_session/models/study_rating.dto.dart';
import 'package:boo_mondai/features/study_session/persistence/study_session.local.store.dart';
import 'package:boo_mondai/features/study_session/rules/study_session_rule.context.dart';
import 'package:boo_mondai/features/study_session/rules/study_session_rule.registry.dart';

final class StudySessionCoordinator {
  const StudySessionCoordinator({
    required StudySessionEngine engine,
    required StudySessionLocalStore store,
    required StudySessionRuleRegistry rules,
  }) : _engine = engine,
       _store = store,
       _rules = rules;

  final StudySessionEngine _engine;
  final StudySessionLocalStore _store;
  final StudySessionRuleRegistry _rules;

  Future<StudySessionRuntime> start({
    required String sessionId,
    required List<SessionStep> steps,
    required DateTime now,
  }) async {
    final runtime = _engine.create(
      sessionId: sessionId,
      steps: steps,
      now: now,
    );
    await _store.saveFlow(runtime.snapshot);
    return runtime;
  }

  StudySessionRuntime? resume(String sessionId) {
    final snapshot = _store.loadFlow(sessionId);
    return snapshot == null ? null : _engine.restore(snapshot);
  }

  Future<StudySessionRuntime> beginSubmission(
    StudySessionRuntime runtime, {
    required String userAnswer,
    required StudyRating rating,
    required DateTime now,
  }) async {
    final pending = PendingStepSubmission(
      stepId: runtime.currentStep!.id,
      userAnswer: userAnswer,
      rating: rating,
      submittedAt: now,
    );
    final updated = _engine.setPendingSubmission(runtime, pending, now);
    await _store.saveFlow(updated.snapshot);
    return updated;
  }

  Future<StudySessionRuntime> finishSubmission(
    StudySessionRuntime runtime, {
    required Iterable<SessionFlowCommand> policyCommands,
    required StudySessionRuleContext ruleContext,
    required DateTime now,
  }) async {
    final ruleCommands = _rules.evaluate(ruleContext);
    var updated = _engine.applyCommands(runtime, [
      ...policyCommands,
      ...ruleCommands,
    ], now);
    updated = _engine.advance(updated, now);
    updated = _engine.clearPendingSubmission(updated, now);
    await _store.saveFlow(updated.snapshot);
    return updated;
  }

  Future<StudySessionRuntime> advancePresentationStep(
    StudySessionRuntime runtime,
    DateTime now,
  ) async {
    if (runtime.currentStep is CardSessionStep) {
      throw StateError('Card steps must be submitted before advancing.');
    }
    final updated = _engine.advance(runtime, now);
    await _store.saveFlow(updated.snapshot);
    return updated;
  }
}
