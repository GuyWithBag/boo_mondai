import 'package:boo_mondai/lib.barrel.dart'
    show
        ChangeRecord,
        ChangeSource,
        ChangeTrackerApply,
        ChangeTrackerEntry,
        ChangeTrackerStatus;

/// A sink that receives progress reports from a change operation workflow.
///
/// Implement this interface to observe and record the lifecycle of a tracked
/// change operation. [ChangeTrackerController] is the standard implementation;
/// a lightweight fake may be used in tests or headless workflows.
///
/// Workflows such as [DeckDownloadsService] accept a [ChangeTrackerReporter]
/// rather than a concrete [ChangeTrackerController] so they remain testable
/// without a widget tree.
abstract interface class ChangeTrackerReporter {
  /// Registers a new tracked operation and returns its entry.
  ///
  /// Call once at the start of a workflow. The returned [ChangeTrackerEntry.id]
  /// must be used for all subsequent calls.
  ChangeTrackerEntry start({
    required ChangeSource source,
    required String title,
    ChangeTrackerStatus status = ChangeTrackerStatus.previewing,
    double? progress,
    List<ChangeRecord> changes = const [],
    ChangeTrackerApply? onApply,
  });

  /// Finds an entry by id, returning null when it has been removed.
  ChangeTrackerEntry? entryById(String entryId);

  /// Updates mutable lifecycle fields on an existing entry.
  ///
  /// Ignored if the entry has already been canceled.
  void update(
    String entryId, {
    ChangeTrackerStatus? status,
    double? progress,
    List<ChangeRecord>? changes,
    String? errorMessage,
    bool clearErrorMessage = false,
  });

  /// Marks the entry as successfully completed.
  ///
  /// Ignored if the entry has already been canceled.
  void complete(String entryId, {List<ChangeRecord>? changes});

  /// Marks the entry as failed and stores a user-visible [error] message.
  ///
  /// Ignored if the entry has already been canceled.
  void fail(String entryId, Object error);

  /// Marks the entry as paused. The caller is responsible for the real pause
  /// signal; this only updates the UI-visible status.
  void pause(String entryId);

  /// Marks a paused entry as applying again.
  ///
  /// No-op if the entry is not currently paused.
  void resume(String entryId);
}
