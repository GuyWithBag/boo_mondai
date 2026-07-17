import 'package:boo_mondai/lib.barrel.dart'
    show
        ChangeType,
        FsrsReviewLog,
        LocalDB,
        RemoteDB,
        SyncIndexEntry,
        SyncTable,
        FsrsCardSyncTable;

class ReviewLogSyncTable extends SyncTable<FsrsReviewLog> {
  ReviewLogSyncTable({required String? deckId})
    : super.appendOnly(
        name: 'review_logs',
        getLocalIndex: (userId) =>
            getLocalReviewLogIndex(userId: userId, deckId: deckId),
        getRemoteIndex: (userId) =>
            getRemoteReviewLogIndex(userId: userId, deckId: deckId),
        getLocalItemsByIds: getLocalReviewLogsByIds,
        getRemoteItemsByIds: getRemoteReviewLogsByIds,
        getItemId: (log) => log.id,
        applyPullItem: LocalDB.reviewLog.upsert,
        applyPushItem: RemoteDB.reviewLog.upsert,
        deleteRemoteItemById: (id) =>
            RemoteDB.reviewLog.deleteWhere({'id': id}),
        changeType: ChangeType.added,
      );

  static Future<List<SyncIndexEntry>> getLocalReviewLogIndex({
    required String userId,
    String? deckId,
  }) async {
    final fsrsCardIds = (await FsrsCardSyncTable.getFsrsCardIds(
      userId: userId,
      deckId: deckId,
    )).toSet();
    return LocalDB.reviewLog.selectSyncIndexByFsrsCardIds(fsrsCardIds);
  }

  static Future<List<SyncIndexEntry>> getRemoteReviewLogIndex({
    required String userId,
    String? deckId,
  }) async {
    final fsrsCardIds = await FsrsCardSyncTable.getFsrsCardIds(
      userId: userId,
      deckId: deckId,
    );
    return RemoteDB.reviewLog.selectSyncIndexByFsrsCardIds(fsrsCardIds);
  }

  static Future<List<FsrsReviewLog>> getLocalReviewLogsByIds(
    String userId,
    List<String> ids,
  ) async {
    return LocalDB.reviewLog.selectManyByIds(ids);
  }

  static Future<List<FsrsReviewLog>> getRemoteReviewLogsByIds(
    String userId,
    List<String> ids,
  ) async {
    return RemoteDB.reviewLog.selectManyByIds(ids);
  }
}
