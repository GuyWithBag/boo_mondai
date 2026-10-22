import 'package:boo_mondai/lib.barrel.dart' show ChangedEntity;

/// Result returned after a batch change operation where entries can fail.
///
/// The generic [TValue] is the successful item type produced by the workflow.
/// Failed items are represented as human-readable messages in [failures] so a
/// caller can show partial success without throwing away successful [values].
class ChangeBatchResult<TValue> {
  /// Creates a batch result from successful [values] and failure messages.
  const ChangeBatchResult({
    required this.values,
    required this.failures,
    this.changes = const [],
  });

  /// Values that were processed successfully.
  final List<TValue> values;

  /// Human-readable failure messages for entries that could not be processed.
  final List<String> failures;

  /// Changes that were produced by successful entries.
  final List<ChangedEntity> changes;
}
