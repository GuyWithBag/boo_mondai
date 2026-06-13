import 'package:boo_mondai/lib.barrel.dart' show ChangeLog;

/// A dry-run description of changes that can be applied later.
class ChangePlan<TPayload> {
  const ChangePlan({required this.payload, required this.changes});

  final TPayload payload;
  final List<ChangeLog> changes;
}
