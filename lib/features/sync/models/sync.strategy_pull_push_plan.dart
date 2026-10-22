import 'package:boo_mondai/lib.barrel.dart' show ChangedEntity;

class SyncStrategyPullPushPlan<T> {
  const SyncStrategyPullPushPlan({
    required this.pullItems,
    required this.pushItems,
    required this.changes,
    this.skipped = 0,
  });

  final List<T> pullItems;
  final List<T> pushItems;
  final List<ChangedEntity<T>> changes;
  final int skipped;

  bool get hasChanges => changes.isNotEmpty;
}
