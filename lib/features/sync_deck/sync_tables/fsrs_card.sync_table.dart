import 'package:boo_mondai/lib.barrel.dart'
    show
        FsrsCard,
        LocalDB,
        RemoteDB,
        SyncIndexEntry,
        SyncTable,
        StudyCardSyncTable;

class FsrsCardSyncTable extends SyncTable<FsrsCard> {
  FsrsCardSyncTable({required String? deckId})
    : super.newestWins(
        name: 'fsrs_cards',
        getLocalIndex: (userId) =>
            getLocalFsrsCardIndex(userId: userId, deckId: deckId),
        getRemoteIndex: (userId) =>
            getRemoteFsrsCardIndex(userId: userId, deckId: deckId),
        getLocalItemsByIds: getLocalFsrsCardsByIds,
        getRemoteItemsByIds: getRemoteFsrsCardsByIds,
        getItemId: (card) => card.id,
        getItemDeletedAt: (card) => card.deletedAt,
        applyPullItem: LocalDB.fsrsCard.upsert,
        applyPushItem: RemoteDB.fsrsSync.upsert,
        deleteRemoteItemById: (id) => RemoteDB.fsrsSync.deleteWhere({'id': id}),
        toMap: RemoteDB.fsrsSync.toMap,
      );

  static Future<List<String>> getFsrsCardIds({
    required String userId,
    String? deckId,
  }) async {
    final localCards = await getLocalFsrsCardIndex(
      userId: userId,
      deckId: deckId,
    );
    final remoteCards = await getRemoteFsrsCardIndex(
      userId: userId,
      deckId: deckId,
    );
    return {
      for (final card in localCards) card.id,
      for (final card in remoteCards) card.id,
    }.toList(growable: false);
  }

  static Future<List<SyncIndexEntry>> getLocalFsrsCardIndex({
    required String userId,
    String? deckId,
  }) async {
    final studyCardIds = (await StudyCardSyncTable.getStudyCardIds(
      userId: userId,
      deckId: deckId,
    )).toSet();
    return LocalDB.fsrsCard.selectSyncIndexByUserIdAndStudyCardIds(
      userId: userId,
      studyCardIds: studyCardIds,
    );
  }

  static Future<List<SyncIndexEntry>> getRemoteFsrsCardIndex({
    required String userId,
    String? deckId,
  }) async {
    final studyCardIds = (await StudyCardSyncTable.getStudyCardIds(
      userId: userId,
      deckId: deckId,
    )).toSet();
    return RemoteDB.fsrsSync.selectSyncIndexByUserIdAndStudyCardIds(
      userId: userId,
      studyCardIds: studyCardIds,
    );
  }

  static Future<List<FsrsCard>> getLocalFsrsCardsByIds(
    String userId,
    List<String> ids,
  ) async {
    return LocalDB.fsrsCard.selectManyByIds(ids);
  }

  static Future<List<FsrsCard>> getRemoteFsrsCardsByIds(
    String userId,
    List<String> ids,
  ) async {
    return RemoteDB.fsrsSync.selectManyByIds(ids, includeDeleted: true);
  }
}
