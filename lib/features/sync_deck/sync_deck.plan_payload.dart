import 'package:boo_mondai/lib.barrel.dart'
    show DeckSyncSession, SyncSummary, SyncPlanStep;

class DeckSyncPlanPayload {
  const DeckSyncPlanPayload({required this.steps});

  final List<SyncPlanStep<DeckSyncSession>> steps;

  SyncSummary get summary {
    var summary = const SyncSummary();
    for (final step in steps) {
      summary = summary.combine(
        SyncSummary(
          pulled: step.pullCount,
          pushed: step.pushCount,
          skipped: step.skipped,
        ),
      );
    }
    return summary;
  }
}
