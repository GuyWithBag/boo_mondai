import 'package:boo_mondai/lib.barrel.dart'
    show
        DeckListing,
        DecksService,
        DeckSyncSession,
        SyncDeletionService,
        SyncIndexEntry;

abstract final class DeckListingsService {
  static Future<List<DeckListing>> loadLocalDeckListingsForSyncSession(
    DeckSyncSession session,
  ) async {
    final deckIds = (await DecksService.loadDeckIdsForSyncSession(
      session,
    )).toSet();
    final deletedIds = await SyncDeletionService.loadDeletedEntityIds(
      session: session,
      entityType: SyncDeletionService.deckListings,
    );
    return SyncDeletionService.withoutDeletedItems(
      session.deckListings.selectManyByDeckIds(deckIds),
      deletedIds,
      (listing) => listing.deckId,
    );
  }

  static Future<List<DeckListing>> loadRemoteDeckListingsForSyncSession(
    DeckSyncSession session,
  ) async {
    final deckIds = await DecksService.loadDeckIdsForSyncSession(session);
    final deletedIds = await SyncDeletionService.loadDeletedEntityIds(
      session: session,
      entityType: SyncDeletionService.deckListings,
    );
    final listings = await session.remoteDeckListings.selectManyByDeckIds(
      deckIds,
    );
    return SyncDeletionService.withoutDeletedItems(
      listings,
      deletedIds,
      (listing) => listing.deckId,
    );
  }

  static Future<List<SyncIndexEntry>>
  loadLocalDeckListingSyncIndexForSyncSession(DeckSyncSession session) async {
    final deckIds = (await DecksService.loadDeckIdsForSyncSession(
      session,
    )).toSet();
    final deletedIds = await SyncDeletionService.loadDeletedEntityIds(
      session: session,
      entityType: SyncDeletionService.deckListings,
    );
    return SyncDeletionService.withoutDeletedIndexEntries(
      session.deckListings.selectSyncIndexByDeckIds(deckIds),
      deletedIds,
    );
  }

  static Future<List<SyncIndexEntry>>
  loadRemoteDeckListingSyncIndexForSyncSession(DeckSyncSession session) async {
    final deckIds = await DecksService.loadDeckIdsForSyncSession(session);
    final deletedIds = await SyncDeletionService.loadDeletedEntityIds(
      session: session,
      entityType: SyncDeletionService.deckListings,
    );
    final entries = await session.remoteDeckListings.selectSyncIndexByDeckIds(
      deckIds,
    );
    return SyncDeletionService.withoutDeletedIndexEntries(entries, deletedIds);
  }

  static Future<List<DeckListing>> loadLocalDeckListingsByIdsForSyncSession(
    DeckSyncSession session,
    List<String> ids,
  ) async {
    final deletedIds = await SyncDeletionService.loadDeletedEntityIds(
      session: session,
      entityType: SyncDeletionService.deckListings,
    );
    return SyncDeletionService.withoutDeletedItems(
      session.deckListings.selectManyByDeckIds(ids.toSet()),
      deletedIds,
      (listing) => listing.deckId,
    );
  }

  static Future<List<DeckListing>> loadRemoteDeckListingsByIdsForSyncSession(
    DeckSyncSession session,
    List<String> ids,
  ) async {
    final deletedIds = await SyncDeletionService.loadDeletedEntityIds(
      session: session,
      entityType: SyncDeletionService.deckListings,
    );
    final listings = await session.remoteDeckListings.selectManyByDeckIds(ids);
    return SyncDeletionService.withoutDeletedItems(
      listings,
      deletedIds,
      (listing) => listing.deckId,
    );
  }
}
