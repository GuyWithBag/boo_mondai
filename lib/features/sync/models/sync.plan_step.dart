import 'package:boo_mondai/lib.barrel.dart'
    show ChangedEntity, SyncStrategy, TypedSyncPlanStep;

abstract class SyncPlanStep<TContext> {
  static Future<SyncPlanStep<TContext>> createFromStrategyPreview<T, TContext>(
    SyncStrategy<T, TContext> strategy,
    TContext context,
  ) async {
    final plan = await strategy.getSyncStrategyPullPushPlan(context);
    return TypedSyncPlanStep<T, TContext>(strategy: strategy, plan: plan);
  }

  List<ChangedEntity<Object?>> get changes;
  int get pullCount;
  int get pushCount;
  int get skipped;
  Future<List<ChangedEntity<Object?>>> apply(TContext context);
}
