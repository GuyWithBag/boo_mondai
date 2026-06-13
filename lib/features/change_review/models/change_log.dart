import 'package:boo_mondai/lib.barrel.dart'
    show ChangeFieldDiff, ChangeSource, ChangeType;

class ChangeLog {
  const ChangeLog({
    required this.type,
    required this.source,
    required this.entityType,
    required this.entityId,
    required this.title,
    this.subtitle,
    this.before,
    this.after,
    this.fields = const [],
    this.localId,
    this.remoteId,
    this.localUpdatedAt,
    this.remoteUpdatedAt,
  });

  final ChangeType type;
  final ChangeSource source;
  final String entityType;
  final String entityId;
  final String title;
  final String? subtitle;
  final Object? before;
  final Object? after;
  final List<ChangeFieldDiff> fields;
  final String? localId;
  final String? remoteId;
  final DateTime? localUpdatedAt;
  final DateTime? remoteUpdatedAt;

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'source': source.name,
    'entity_type': entityType,
    'entity_id': entityId,
    'title': title,
    if (subtitle != null) 'subtitle': subtitle,
    if (before != null) 'before': before.toString(),
    if (after != null) 'after': after.toString(),
    if (fields.isNotEmpty)
      'fields': [for (final field in fields) field.toJson()],
    if (localId != null) 'local_id': localId,
    if (remoteId != null) 'remote_id': remoteId,
    if (localUpdatedAt != null)
      'local_updated_at': localUpdatedAt!.toIso8601String(),
    if (remoteUpdatedAt != null)
      'remote_updated_at': remoteUpdatedAt!.toIso8601String(),
  };
}
