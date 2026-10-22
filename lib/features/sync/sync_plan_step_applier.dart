import 'package:boo_mondai/lib.barrel.dart' show ChangedEntity, SyncPlanStep;

class SyncPlanStepApplier {
  const SyncPlanStepApplier._();

  static Future<List<ChangedEntity<Object?>>> applyAll({
    required List<SyncPlanStep> steps,
    required String profileId,
    void Function(double progress)? onProgressChanged,
  }) async {
    final appliedChanges = <ChangedEntity<Object?>>[];

    if (steps.isEmpty) {
      onProgressChanged?.call(1);
      return appliedChanges;
    }

    for (var i = 0; i < steps.length; i++) {
      onProgressChanged?.call(i / steps.length);
      appliedChanges.addAll(await steps[i].apply(profileId: profileId));
    }

    onProgressChanged?.call(1);
    return appliedChanges;
  }

  static Future<List<ChangedEntity<Object?>>> discardAll({
    required List<SyncPlanStep> steps,
    required String profileId,
    void Function(double progress)? onProgressChanged,
  }) async {
    final appliedChanges = <ChangedEntity<Object?>>[];

    if (steps.isEmpty) {
      onProgressChanged?.call(1);
      return appliedChanges;
    }

    final reversedSteps = steps.reversed.toList(growable: false);
    for (var i = 0; i < reversedSteps.length; i++) {
      onProgressChanged?.call(i / reversedSteps.length);
      appliedChanges.addAll(
        await reversedSteps[i].discard(profileId: profileId),
      );
    }

    onProgressChanged?.call(1);
    return appliedChanges;
  }
}
