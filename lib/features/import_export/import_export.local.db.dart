import 'package:boo_mondai/lib.barrel.dart'
    show HiveLocalDB, ImportExportBackup;

/// Hive storage for persisted import/export payload backups.
class ImportExportBackupsLocalDB extends HiveLocalDB<ImportExportBackup> {
  @override
  String get boxName => 'import_export_backups';

  @override
  Map<String, Object?> primaryKeyFromItem(ImportExportBackup item) => {
    'id': item.id,
  };

  /// Returns newest backups first.
  List<ImportExportBackup> getRecent({int limit = 100}) => guardSync(() {
    final rows = box.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return rows.take(limit).toList(growable: false);
  }, action: 'getRecent($limit)');
}
