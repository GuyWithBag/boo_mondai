/// Lifecycle states for a [ChangeTrackerEntry].
///
/// The common review-first path is [planning] -> [fetching] -> [reviewing] ->
/// [applying] -> [completed]. Workflows may also move to [failed], [canceled],
/// [paused], or [alreadyUpToDate] depending on user action and feature needs.
enum ChangeTrackerStatus {
  /// No operation has started. Initial state before [ChangeTrackerController.start].
  idle,

  /// The operation is discovering what will change. Progress is indeterminate.
  planning,

  /// The operation is loading local or remote data needed to build a plan.
  fetching,

  /// Changes have been computed and are awaiting user confirmation.
  reviewing,

  /// The operation is temporarily suspended and may be resumed.
  paused,

  /// The operation is actively writing changes.
  applying,

  /// The operation completed successfully.
  completed,

  /// The operation encountered an unrecoverable error.
  failed,

  /// The operation was canceled by the user or caller before completion.
  canceled,

  /// The preview found no differences; nothing needs to be applied.
  /// Reserved for future use.
  alreadyUpToDate,
}
