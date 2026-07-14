import 'package:boo_mondai/lib.barrel.dart'
    show SyncStrategyPullPushPlan, ChangedEntity, DeckSyncSession;

abstract class SyncStrategy<T> {
  String get name;

  Future<bool> doesItNeedSync(DeckSyncSession context);

  Future<SyncStrategyPullPushPlan<T>> getSyncStrategyPullPushPlan(
    DeckSyncSession context,
  );

  Future<List<ChangedEntity<T>>> applySyncStrategyPullPushPlan(
    SyncStrategyPullPushPlan<T> plan,
    DeckSyncSession context,
  );
}
