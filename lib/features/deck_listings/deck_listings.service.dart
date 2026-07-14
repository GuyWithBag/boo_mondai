import 'package:boo_mondai/lib.barrel.dart'
    show DeckListing, DecksService, DeckSyncSession, SyncIndexEntry;

abstract final class DeckListingsService {
  static Future<List<DeckListing>> loadLocalDeckListingsForSyncSession(
    DeckSyncSession session,
  ) async {
    final deckIds = (await DecksService.loadDeckIdsForSyncSession(
      session,
    )).toSet();
    return session.deckListings.selectManyByDeckIds(deckIds);
  }

  static Future<List<DeckListing>> loadRemoteDeckListingsForSyncSession(
    DeckSyncSession session,
  ) async {
    final deckIds = await DecksService.loadDeckIdsForSyncSession(session);
    return session.remoteDeckListings.selectManyByDeckIds(deckIds);
  }

  static Future<List<SyncIndexEntry>>
  loadLocalDeckListingSyncIndexForSyncSession(DeckSyncSession session) async {
    final deckIds = (await DecksService.loadDeckIdsForSyncSession(
      session,
    )).toSet();
    return session.deckListings.selectSyncIndexByDeckIds(deckIds);
  }

  static Future<List<SyncIndexEntry>>
  loadRemoteDeckListingSyncIndexForSyncSession(DeckSyncSession session) async {
    final deckIds = await DecksService.loadDeckIdsForSyncSession(session);
    return session.remoteDeckListings.selectSyncIndexByDeckIds(deckIds);
  }

  static Future<List<DeckListing>> loadLocalDeckListingsByIdsForSyncSession(
    DeckSyncSession session,
    List<String> ids,
  ) async {
    return session.deckListings.selectManyByDeckIds(ids.toSet());
  }

  static Future<List<DeckListing>> loadRemoteDeckListingsByIdsForSyncSession(
    DeckSyncSession session,
    List<String> ids,
  ) async {
    return session.remoteDeckListings.selectManyByDeckIds(ids);
  }
}
