import 'package:boo_mondai/lib.barrel.dart' show SyncChangeLog;

class SyncResult {
  const SyncResult({
    this.changes = const [],
    this.pulled = 0,
    this.pushed = 0,
    this.skipped = 0,
  });

  final List<SyncChangeLog> changes;
  final int pulled;
  final int pushed;
  final int skipped;

  SyncResult combine(SyncResult other) {
    return SyncResult(
      changes: [...changes, ...other.changes],
      pulled: pulled + other.pulled,
      pushed: pushed + other.pushed,
      skipped: skipped + other.skipped,
    );
  }
}
