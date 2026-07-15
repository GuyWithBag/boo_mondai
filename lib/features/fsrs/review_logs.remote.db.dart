import 'package:boo_mondai/lib.barrel.dart'
    show FsrsReviewLog, SupabaseRemoteDB, SyncIndexEntry;
import 'package:fsrs/fsrs.dart' as fsrs;

class ReviewLogsRemoteDB extends SupabaseRemoteDB<FsrsReviewLog> {
  @override
  String get tableName => 'review_logs';

  @override
  FsrsReviewLog Function(Map<String, dynamic>) get fromMap =>
      _fsrsReviewLogFromMap;

  @override
  Map<String, dynamic> toMap(FsrsReviewLog item) {
    return {
      'id': item.id,
      'created_at': item.createdAt.toIso8601String(),
      'fsrs_card_id': item.fsrsCardId,
      'log': item.log.toMap(),
    };
  }

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

  FsrsReviewLog _fsrsReviewLogFromMap(Map<String, dynamic> map) {
    return FsrsReviewLog(
      id: map['id'] as String,
      createdAt: _dateTimeFromMap(map, 'created_at'),
      fsrsCardId: map['fsrs_card_id'] as String,
      log: _logFromMap(map['log']),
    );
  }

  DateTime _dateTimeFromMap(Map<String, dynamic> map, String key) {
    final value = map[key];
    if (value is DateTime) return value;
    return DateTime.parse(value as String);
  }

  fsrs.ReviewLog _logFromMap(Object? value) {
    if (value is fsrs.ReviewLog) return value;
    final map = Map<String, dynamic>.from(value as Map);
    return fsrs.ReviewLog.fromMap(map);
  }
}
