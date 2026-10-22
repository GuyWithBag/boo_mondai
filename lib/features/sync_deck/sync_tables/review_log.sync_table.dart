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
        getLocalIndex: (profileId) =>
            getLocalReviewLogIndex(profileId: profileId, deckId: deckId),
        getRemoteIndex: (profileId) =>
            getRemoteReviewLogIndex(profileId: profileId, deckId: deckId),
        getLocalItemsByIds: getLocalReviewLogsByIds,
        getRemoteItemsByIds: getRemoteReviewLogsByIds,
        getItemId: (log) => log.id,
        applyPullItem: LocalDB.reviewLogs.upsert,
        applyPushItem: RemoteDB.reviewLogs.upsert,
        deleteRemoteItemById: (id) => RemoteDB.reviewLogs.delete({'id': id}),
        changeType: ChangeType.added,
      );

  static Future<List<SyncIndexEntry>> getLocalReviewLogIndex({
    required String profileId,
    String? deckId,
  }) async {
    final fsrsCardIds = (await FsrsCardSyncTable.getFsrsCardIds(
      profileId: profileId,
      deckId: deckId,
    )).toSet();
    return LocalDB.reviewLogs.selectSyncIndexByFsrsCardIds(fsrsCardIds);
  }

  static Future<List<SyncIndexEntry>> getRemoteReviewLogIndex({
    required String profileId,
    String? deckId,
  }) async {
    final fsrsCardIds = await FsrsCardSyncTable.getFsrsCardIds(
      profileId: profileId,
      deckId: deckId,
    );
    return RemoteDB.reviewLogs.selectSyncIndexByFsrsCardIds(fsrsCardIds);
  }

  static Future<List<FsrsReviewLog>> getLocalReviewLogsByIds(
    String profileId,
    List<String> ids,
  ) async {
    return LocalDB.reviewLogs.selectManyByIds(ids);
  }

  static Future<List<FsrsReviewLog>> getRemoteReviewLogsByIds(
    String profileId,
    List<String> ids,
  ) async {
    return RemoteDB.reviewLogs.selectManyByIds(ids);
  }
}
