// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/local/deck_listing_local.db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show HiveLocalDB, DeckListing, SyncIndexEntry;

class DeckListingsLocalDB extends HiveLocalDB<DeckListing> {
  @override
  String get boxName => 'deck_listings';

  @override
  Map<String, Object?> primaryKeyFromItem(DeckListing item) => {
    'deck_id': item.deckId,
  };

  List<DeckListing> selectManyByDeckIds(Set<String> deckIds) => guardSync(
    () => selectMany(where: (listing) => deckIds.contains(listing.deckId)),
    action: 'selectManyByDeckIds(${deckIds.length} deckIds)',
  );

  List<SyncIndexEntry> selectSyncIndexByDeckIds(
    Set<String> deckIds,
  ) => guardSync(
    () => selectManyByDeckIds(deckIds)
        .map(
          (listing) =>
              SyncIndexEntry(id: listing.deckId, updatedAt: listing.updatedAt),
        )
        .toList(growable: false),
    action: 'selectSyncIndexByDeckIds(${deckIds.length} deckIds)',
  );

  // ── All standard CRUD (put, getById, delete, etc.) is inherited! ──
}
