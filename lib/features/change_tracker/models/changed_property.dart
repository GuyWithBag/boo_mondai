/// The before and after value of a single labeled property within a
/// [ChangeRecord] of type [ChangeType.modified].
///
/// Used by [ChangeComparer] to produce field-level diffs and rendered
/// by [ChangeTrackerFieldDiff] in the review UI.
class ChangedProperty {
  const ChangedProperty({required this.propertyLabel, this.before, this.after});

  /// User-facing label for this property, such as `Title` or `Tags`.
  final String propertyLabel;

  /// Property value before the change, or null for additions.
  final Object? before;

  /// Property value after the change, or null for removals.
  final Object? after;

  /// Serializes this property diff for debug output.
  Map<String, dynamic> toJson() => {
    'property_label': propertyLabel,
    if (before != null) 'before': before.toString(),
    if (after != null) 'after': after.toString(),
  };
}
