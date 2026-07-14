import 'package:boo_mondai/lib.barrel.dart'
    show
        ChangedEntity,
        DeckSyncSession,
        SyncPlanStep,
        SyncStrategy,
        SyncStrategyPullPushPlan;

class TypedSyncPlanStep<T> implements SyncPlanStep {
  const TypedSyncPlanStep({required this.strategy, required this.plan});

  final SyncStrategy<T> strategy;
  final SyncStrategyPullPushPlan<T> plan;

  @override
  List<ChangedEntity<Object?>> get changes =>
      plan.changes.cast<ChangedEntity<Object?>>();

  @override
  int get pullCount => plan.pullItems.length;

  @override
  int get pushCount => plan.pushItems.length;

  @override
  int get skipped => plan.skipped;

  @override
  Future<List<ChangedEntity<Object?>>> apply(DeckSyncSession session) async {
    final applied = await strategy.applySyncStrategyPullPushPlan(plan, session);
    return applied.cast<ChangedEntity<Object?>>();
  }
}
