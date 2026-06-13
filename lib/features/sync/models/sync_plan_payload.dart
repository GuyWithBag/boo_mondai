import 'package:boo_mondai/lib.barrel.dart' show DTO;

class SyncPlanPayload<T extends DTO> {
  const SyncPlanPayload({
    required this.tableName,
    required this.pullItems,
    required this.pushItems,
    required this.skipped,
  });

  final String tableName;
  final List<T> pullItems;
  final List<T> pushItems;
  final int skipped;

  SyncSummary get summary => SyncSummary(
    pulled: pullItems.length,
    pushed: pushItems.length,
    skipped: skipped,
  );
}

class SyncSummary {
  const SyncSummary({this.pulled = 0, this.pushed = 0, this.skipped = 0});

  final int pulled;
  final int pushed;
  final int skipped;

  SyncSummary combine(SyncSummary other) {
    return SyncSummary(
      pulled: pulled + other.pulled,
      pushed: pushed + other.pushed,
      skipped: skipped + other.skipped,
    );
  }
}
