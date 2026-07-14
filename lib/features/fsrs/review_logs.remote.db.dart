import 'package:boo_mondai/lib.barrel.dart'
    show FsrsReviewLog, FsrsReviewLogMapper, SupabaseRemoteDB, SyncIndexEntry;

class ReviewLogsRemoteDB extends SupabaseRemoteDB<FsrsReviewLog> {
  @override
  String get tableName => 'review_logs';

  @override
  FsrsReviewLog Function(Map<String, dynamic>) get fromMap =>
      FsrsReviewLogMapper.fromMap;

  @override
  Map<String, dynamic> toMap(FsrsReviewLog item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(FsrsReviewLog item) => {
    'id': item.id,
  };

  @override
  String get upsertConflictTarget => 'id';

  Future<List<FsrsReviewLog>> selectManyByFsrsCardId(String fsrsCardId) =>
      selectMany(filters: {'fsrs_card_id': fsrsCardId});

  Future<List<FsrsReviewLog>> selectManyByFsrsCardIds(
    List<String> fsrsCardIds,
  ) async {
    final logs = <FsrsReviewLog>[];
    for (final fsrsCardId in fsrsCardIds) {
      logs.addAll(await selectManyByFsrsCardId(fsrsCardId));
    }
    return logs;
  }

  Future<List<FsrsReviewLog>> selectManyByIds(List<String> ids) async {
    final logs = <FsrsReviewLog>[];
    for (final id in ids) {
      final log = await selectOne(filters: {'id': id});
      if (log != null) logs.add(log);
    }
    return logs;
  }

  Future<List<SyncIndexEntry>> selectSyncIndexByFsrsCardIds(
    List<String> fsrsCardIds,
  ) => guard(() async {
    if (fsrsCardIds.isEmpty) return const <SyncIndexEntry>[];

    final response = await client
        .from(tableName)
        .select('id, created_at')
        .inFilter('fsrs_card_id', fsrsCardIds);
    return List<Map<String, dynamic>>.from(response)
        .map(
          (row) => SyncIndexEntry(
            id: row['id'] as String,
            updatedAt: DateTime.parse(row['created_at'] as String),
          ),
        )
        .toList(growable: false);
  }, action: 'selectSyncIndexByFsrsCardIds(${fsrsCardIds.length} fsrsCardIds)');

  Future<List<SyncIndexEntry>> selectSyncIndexByFsrsCardId(String fsrsCardId) =>
      guard(() async {
        final response = await client
            .from(tableName)
            .select('id, created_at')
            .eq('fsrs_card_id', fsrsCardId);
        return List<Map<String, dynamic>>.from(response)
            .map(
              (row) => SyncIndexEntry(
                id: row['id'] as String,
                updatedAt: DateTime.parse(row['created_at'] as String),
              ),
            )
            .toList(growable: false);
      }, action: 'selectSyncIndexByFsrsCardId($fsrsCardId)');
}
