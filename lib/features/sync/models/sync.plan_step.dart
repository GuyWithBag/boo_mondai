import 'package:boo_mondai/lib.barrel.dart'
    show ChangedEntity, SyncTable, TypedSyncPlanStep;

abstract class SyncPlanStep {
  static Future<SyncPlanStep> createFromTablePreview<T>(
    SyncTable<T> table, {
    required String profileId,
  }) async {
    final plan = await table.getSyncPlan(profileId: profileId);
    return TypedSyncPlanStep<T>(table: table, plan: plan);
  }

  List<ChangedEntity<Object?>> get changes;
  int get pullCount;
  int get pushCount;
  int get skipped;
  Future<List<ChangedEntity<Object?>>> apply({required String profileId});
  Future<List<ChangedEntity<Object?>>> discard({required String profileId});
}
