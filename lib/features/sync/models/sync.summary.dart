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
