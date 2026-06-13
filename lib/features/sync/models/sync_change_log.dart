import 'package:boo_mondai/lib.barrel.dart' show SyncChangeType;

/// User-facing description of one sync/download decision.
class SyncChangeLog {
  const SyncChangeLog({
    required this.type,
    required this.entityType,
    required this.entityId,
    required this.message,
    this.localId,
    this.remoteId,
    this.localUpdatedAt,
    this.remoteUpdatedAt,
  });

  final SyncChangeType type;
  final String entityType;
  final String entityId;
  final String message;
  final String? localId;
  final String? remoteId;
  final DateTime? localUpdatedAt;
  final DateTime? remoteUpdatedAt;
}
