import 'package:boo_mondai/features/study_session/models/session_flow_snapshot.dto.dart';
import 'package:boo_mondai/features/study_session/models/session_step.dto.dart';

final class StudySessionRuntime {
  const StudySessionRuntime(this.snapshot);

  final SessionFlowSnapshot snapshot;

  int get currentStepIndex {
    final currentStepId = snapshot.currentStepId;
    if (currentStepId == null) return snapshot.steps.length;
    return snapshot.steps.indexWhere((step) => step.id == currentStepId);
  }

  SessionStep? get currentStep {
    final index = currentStepIndex;
    if (index < 0 || index >= snapshot.steps.length) return null;
    return snapshot.steps[index];
  }

  bool get isComplete => snapshot.currentStepId == null;

  int get completedCardCount {
    final index = currentStepIndex;
    final completed = index < 0 ? snapshot.steps.length : index;
    return snapshot.steps.take(completed).whereType<CardSessionStep>().length;
  }

  int get plannedCardCount => snapshot.steps
      .whereType<CardSessionStep>()
      .where((step) => step.attemptNumber == 1)
      .length;

  double get cardProgress {
    final total = plannedCardCount;
    if (total == 0) return isComplete ? 1 : 0;
    return (completedCardCount / total).clamp(0, 1);
  }
}
