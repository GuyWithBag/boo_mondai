import 'package:boo_mondai/lib.barrel.dart'
    show ChangedProperty, ChangeSource, ChangeType;

/// A single human-readable record of one entity-level change within a
/// [ChangePreview] or a completed [ChangeTrackerEntry].
///
/// Each record describes what happened to one entity (a deck, a card template,
/// etc.) and optionally holds [ChangedProperty] entries for field-level detail.
class ChangeRecord {
  /// Creates a record for one entity-level operation.
  const ChangeRecord({
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

  /// Operation type: added, modified, removed, or skipped.
  final ChangeType type;

  /// Workflow that produced the change.
  final ChangeSource source;

  /// Storage or domain entity name, such as `deck` or `card_template`.
  final String entityType;

  /// Identifier of the affected entity in the source workflow.
  final String entityId;

  /// Primary text shown in review lists.
  final String title;

  /// Optional explanatory text shown under [title].
  final String? subtitle;

  /// Entity snapshot before the change.
  final Object? before;

  /// Entity snapshot after the change.
  final Object? after;

  /// Property-level diffs for modified entities.
  final List<ChangedProperty> fields;

  /// Local identifier when the change compares local and remote records.
  final String? localId;

  /// Remote identifier when the change compares local and remote records.
  final String? remoteId;

  /// Local record timestamp used for conflict/change explanations.
  final DateTime? localUpdatedAt;

  /// Remote record timestamp used for conflict/change explanations.
  final DateTime? remoteUpdatedAt;

  /// Converts this record into a serializable map for debug output.
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
