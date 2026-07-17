import 'package:boo_mondai/lib.barrel.dart'
    show ChangedEntity, SyncPlanStep, SyncTable, SyncStrategyPullPushPlan;

class TypedSyncPlanStep<T> implements SyncPlanStep {
  const TypedSyncPlanStep({required this.table, required this.plan});

  final SyncTable<T> table;
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
  Future<List<ChangedEntity<Object?>>> apply({required String userId}) async {
    final applied = await table.applySyncPlan(plan, userId: userId);
    return applied.cast<ChangedEntity<Object?>>();
  }

  @override
  Future<List<ChangedEntity<Object?>>> discard({required String userId}) async {
    final applied = await table.discardRemoteChanges(plan, userId: userId);
    return applied.cast<ChangedEntity<Object?>>();
  }
}
