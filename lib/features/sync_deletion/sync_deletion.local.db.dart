import 'package:boo_mondai/lib.barrel.dart'
    show HiveLocalDB, SyncDeletion, SyncIndexEntry;

class SyncDeletionLocalDB extends HiveLocalDB<SyncDeletion> {
  @override
  String get boxName => 'sync_deletions';

  @override
  Map<String, Object?> primaryKeyFromItem(SyncDeletion item) => {'id': item.id};

  List<SyncDeletion> selectManyByUserId(String userId) => guardSync(
    () => selectMany(where: (deletion) => deletion.userId == userId),
    action: 'selectManyByUserId($userId)',
  );

  List<SyncDeletion> selectManyByUserIdAndEntityType({
    required String userId,
    required String entityType,
  }) => guardSync(
    () => selectMany(
      where: (deletion) =>
          deletion.userId == userId && deletion.entityType == entityType,
    ),
    action: 'selectManyByUserIdAndEntityType($userId, $entityType)',
  );

  List<SyncIndexEntry> selectSyncIndexByUserId(String userId) =>
      selectSyncIndexWhere(
        where: (deletion) => deletion.userId == userId,
        getId: (deletion) => deletion.id,
        getUpdatedAt: (deletion) => deletion.deletedAt,
        action: 'selectSyncIndexByUserId($userId)',
      );

  List<SyncDeletion> selectManyByIds(List<String> ids) => guardSync(
    () => [
      for (final id in ids) ?selectByPk({'id': id}),
    ],
    action: 'selectManyByIds(${ids.length} ids)',
  );
}
