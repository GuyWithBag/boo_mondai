/// Operation type represented by a [ChangedEntity].
enum ChangeType {
  /// Entity will be created or copied in.
  added,

  /// Existing entity will be changed.
  modified,

  /// Entity will be deleted or removed from scope.
  removed,

  /// Entity was inspected but does not need mutation.
  skipped,
}
