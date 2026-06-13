/// Type of record-level change discovered or applied by sync-like workflows.
enum SyncChangeType {
  created,
  updated,
  deletedRemotely,
  skipped,
  unchanged,
  failed,
}
