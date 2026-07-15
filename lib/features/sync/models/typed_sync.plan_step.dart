import 'package:boo_mondai/lib.barrel.dart'
    show ChangedEntity, SyncPlanStep, SyncStrategy, SyncStrategyPullPushPlan;

class TypedSyncPlanStep<T, TContext> implements SyncPlanStep<TContext> {
  const TypedSyncPlanStep({required this.strategy, required this.plan});

  final SyncStrategy<T, TContext> strategy;
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
  Future<List<ChangedEntity<Object?>>> apply(TContext context) async {
    final applied = await strategy.applySyncStrategyPullPushPlan(plan, context);
    return applied.cast<ChangedEntity<Object?>>();
  }
}
