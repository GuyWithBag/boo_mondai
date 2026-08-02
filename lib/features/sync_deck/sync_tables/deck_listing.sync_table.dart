import 'package:boo_mondai/lib.barrel.dart'
    show
        DeckListing,
        DeckListingMediaSyncPreprocessor,
        LocalDB,
        RemoteDB,
        SyncIndexEntry,
        SyncTable,
        DeckSyncTable;

class DeckListingSyncTable extends SyncTable<DeckListing> {
  DeckListingSyncTable({required String? deckId})
    : super.newestWins(
        name: 'deck_listings',
        getLocalIndex: (profileId) =>
            getLocalDeckListingIndex(profileId: profileId, deckId: deckId),
        getRemoteIndex: (profileId) =>
            getRemoteDeckListingIndex(profileId: profileId, deckId: deckId),
        getLocalItemsByIds: getLocalDeckListingsByIds,
        getRemoteItemsByIds: getRemoteDeckListingsByIds,
        getItemId: (listing) => listing.deckId,
        getItemDeletedAt: (listing) => listing.deletedAt,
        applyPullItem: LocalDB.deckListing.upsert,
        applyPushItem: RemoteDB.deckListing.upsert,
        deleteRemoteItemById: (id) =>
            RemoteDB.deckListing.deleteWhere({'deck_id': id}),
        preprocessPushItem: (listing, profileId) =>
            DeckListingMediaSyncPreprocessor.preprocessPushItem(
              listing: listing,
              profileId: profileId,
            ),
        toMap: RemoteDB.deckListing.toMap,
      );

  static Future<List<SyncIndexEntry>> getLocalDeckListingIndex({
    required String profileId,
    String? deckId,
  }) async {
    final deckIds = (await DeckSyncTable.getDeckIds(
      profileId: profileId,
      deckId: deckId,
    )).toSet();
    return LocalDB.deckListing.selectSyncIndexByDeckIds(deckIds);
  }

  static Future<List<SyncIndexEntry>> getRemoteDeckListingIndex({
    required String profileId,
    String? deckId,
  }) async {
    final deckIds = await DeckSyncTable.getDeckIds(
      profileId: profileId,
      deckId: deckId,
    );
    return RemoteDB.deckListing.selectSyncIndexByDeckIds(deckIds);
  }

  static Future<List<DeckListing>> getLocalDeckListingsByIds(
    String profileId,
    List<String> ids,
  ) async {
    return LocalDB.deckListing.selectManyByDeckIdsIncludingDeleted(ids.toSet());
  }

  static Future<List<DeckListing>> getRemoteDeckListingsByIds(
    String profileId,
    List<String> ids,
  ) async {
    return RemoteDB.deckListing.selectManyByDeckIds(ids, includeDeleted: true);
  }
}
