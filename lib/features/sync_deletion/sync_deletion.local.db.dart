import 'package:boo_mondai/lib.barrel.dart'
    show HiveLocalDB, SyncDeletion, SyncIndexEntry;

class SyncDeletionLocalDB extends HiveLocalDB<SyncDeletion> {
  @override
  String get boxName => 'sync_deletions';

  @override
  Map<String, Object?> primaryKeyFromItem(SyncDeletion item) => {'id': item.id};

  List<SyncDeletion> selectManyByUserId(String profileId) => guardSync(
    () => selectMany(where: (deletion) => deletion.profileId == profileId),
    action: 'selectManyByUserId($profileId)',
  );

  List<SyncDeletion> selectManyByUserIdAndEntityType({
    required String profileId,
    required String entityType,
  }) => guardSync(
    () => selectMany(
      where: (deletion) =>
          deletion.profileId == profileId && deletion.entityType == entityType,
    ),
    action: 'selectManyByUserIdAndEntityType($profileId, $entityType)',
  );

  List<SyncIndexEntry> selectSyncIndexByUserId(String profileId) =>
      selectSyncIndexWhere(
        where: (deletion) => deletion.profileId == profileId,
        getId: (deletion) => deletion.id,
        getUpdatedAt: (deletion) => deletion.deletedAt,
        action: 'selectSyncIndexByUserId($profileId)',
      );

  List<SyncDeletion> selectManyByIds(List<String> ids) => guardSync(
    () => [
      for (final id in ids) ?selectByPk({'id': id}),
    ],
    action: 'selectManyByIds(${ids.length} ids)',
  );
}
