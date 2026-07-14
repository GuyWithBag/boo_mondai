import 'package:boo_mondai/lib.barrel.dart'
    show ChangedEntity, DeckSyncSession, SyncStrategy, TypedSyncPlanStep;

// todo: review this and typed sync plan step if it is still necessary

abstract class SyncPlanStep {
  static Future<SyncPlanStep> createFromStrategyPreview<T>(
    SyncStrategy<T> strategy,
    DeckSyncSession session,
  ) async {
    final plan = await strategy.getSyncStrategyPullPushPlan(session);
    return TypedSyncPlanStep<T>(strategy: strategy, plan: plan);
  }

  List<ChangedEntity<Object?>> get changes;
  int get pullCount;
  int get pushCount;
  int get skipped;
  Future<List<ChangedEntity<Object?>>> apply(DeckSyncSession session);
}
