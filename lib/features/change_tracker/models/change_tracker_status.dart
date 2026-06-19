/// Lifecycle states for a [ChangeTrackerEntry].
enum ChangeTrackerStatus {
  /// No operation has started. Initial state before [ChangeTrackerController.start].
  idle,

  /// The operation is discovering what will change. Progress is indeterminate.
  previewing,

  /// Changes have been computed and are awaiting user confirmation.
  reviewing,

  /// The operation has finished and result details are ready for display.
  /// Reserved for future use.
  results,

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
