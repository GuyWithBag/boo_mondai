import 'package:boo_mondai/lib.barrel.dart';

/// The before and after value of a single labeled property within a
/// [ChangedEntity] of type [ChangeType.modified].
///
/// Used by [ChangeDifferenceHelper] to produce field-level diffs and rendered
/// by [ChangedPropertyBlock] in the review UI.
class ChangedProperty<T> {
  /// Creates a display-ready property diff.
  const ChangedProperty({
    required this.propertyLabel,
    this.before,
    this.after,
    required this.type,
  });

  /// User-facing label for this property, such as `Title` or `Tags`.
  final String propertyLabel;

  final ChangeType type;

  /// Property value before the change, or null for additions.
  final T? before;

  /// Property value after the change, or null for removals.
  final T? after;

  /// Serializes this property diff for debug output.
  Map<String, dynamic> toJson() => {
    'property_label': propertyLabel,
    if (before != null) 'before': before.toString(),
    if (after != null) 'after': after.toString(),
  };
}
