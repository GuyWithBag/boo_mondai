import 'package:boo_mondai/lib.barrel.dart' show ChangedEntity;

/// Result returned after a change operation mutates data.
///
/// Use this for the apply phase of a workflow. [value] is the domain result
/// needed by the caller, while [changes] is the audit/review summary that can
/// be shown by the change tracker after mutation succeeds.
class ChangeResult<TValue, TEntity> {
  /// Creates a successful mutation result with optional change logs.
  const ChangeResult({required this.value, this.changes = const []});

  /// Result value produced by the workflow.
  final TValue value;

  /// Changes that were actually applied.
  final List<ChangedEntity<TEntity>> changes;
}
