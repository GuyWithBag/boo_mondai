import 'package:boo_mondai/lib.barrel.dart' show ChangeLog;

/// Result returned after a change operation mutates data.
class ChangeResult<TValue> {
  const ChangeResult({required this.value, this.changes = const []});

  final TValue value;
  final List<ChangeLog> changes;
}

/// Result returned after a batch change operation where entries can fail.
class ChangeBatchResult<TValue> {
  const ChangeBatchResult({
    required this.values,
    required this.failures,
    this.changes = const [],
  });

  final List<TValue> values;
  final List<String> failures;
  final List<ChangeLog> changes;
}
