import 'package:boo_mondai/lib.barrel.dart' show ChangeRecord;

/// Result returned after a change operation mutates data.
class ChangeResult<TValue> {
  /// Creates a successful mutation result with optional change logs.
  const ChangeResult({required this.value, this.changes = const []});

  /// Result value produced by the workflow.
  final TValue value;

  /// Changes that were actually applied.
  final List<ChangeRecord> changes;
}
