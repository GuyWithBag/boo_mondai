import 'package:boo_mondai/lib.barrel.dart' show MutableEntity, SyncSummary;

class SyncPlanPayload<T extends MutableEntity> {
  const SyncPlanPayload({
    required this.tableName,
    required this.checkpointTargetId,
    required this.pullItems,
    required this.pushItems,
    required this.skipped,
  });

  final String tableName;
  final String checkpointTargetId;
  final List<T> pullItems;
  final List<T> pushItems;
  final int skipped;

  SyncSummary get summary => SyncSummary(
    pulled: pullItems.length,
    pushed: pushItems.length,
    skipped: skipped,
  );
}
