import 'package:boo_mondai/lib.barrel.dart'
    show SyncStrategyPullPushPlan, ChangedEntity;

abstract class SyncStrategy<T, TContext> {
  String get name;

  Future<bool> doesItNeedSync(TContext context);

  Future<SyncStrategyPullPushPlan<T>> getSyncStrategyPullPushPlan(
    TContext context,
  );

  Future<List<ChangedEntity<T>>> applySyncStrategyPullPushPlan(
    SyncStrategyPullPushPlan<T> plan,
    TContext context,
  );
}
