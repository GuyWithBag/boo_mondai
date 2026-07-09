import 'package:dart_mappable/dart_mappable.dart';

part 'import_export_backup.dto.mapper.dart';

/// Persisted local record of one import/export payload and its change log.
@MappableClass()
class ImportExportBackup with ImportExportBackupMappable {
  /// Creates a backup record.
  const ImportExportBackup({
    required this.id,
    required this.operation,
    required this.type,
    this.entityId,
    required this.title,
    required this.payloadJson,
    required this.changeLogsJson,
    required this.createdAt,
  });

  /// Local primary key.
  final String id;

  /// Operation label such as `export_deck` or `import_cards`.
  final String operation;

  /// Target entity type such as `deck`, `decks`, or `card_templates`.
  final String type;

  /// Optional local entity id.
  final String? entityId;

  /// Short user-facing title for backup/history lists.
  final String title;

  /// Serialized payload JSON.
  final String payloadJson;

  /// Serialized change log JSON.
  final String changeLogsJson;

  /// Creation timestamp for sorting and retention policies.
  final DateTime createdAt;
}
