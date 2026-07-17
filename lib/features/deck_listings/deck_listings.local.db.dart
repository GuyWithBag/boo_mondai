// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/local/deck_listing_local.db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show DeckListing, HiveLocalDB, HivePrimaryKey, SyncIndexEntry;

class DeckListingsLocalDB extends HiveLocalDB<DeckListing> {
  @override
  String get boxName => 'deck_listings';

  @override
  Map<String, Object?> primaryKeyFromItem(DeckListing item) => {
    'deck_id': item.deckId,
  };

  @override
  DateTime? getDeletedAt(DeckListing item) => item.deletedAt;

  DeckListing? selectByPkIncludingDeleted(HivePrimaryKey primaryKey) {
    return selectByPk(primaryKey, includeDeleted: true);
  }

  List<DeckListing> selectManyByDeckIds(Set<String> deckIds) => guardSync(
    () => selectMany(where: (listing) => deckIds.contains(listing.deckId)),
    action: 'selectManyByDeckIds(${deckIds.length} deckIds)',
  );

  List<DeckListing> selectManyByDeckIdsIncludingDeleted(Set<String> deckIds) =>
      guardSync(
        () => selectManyIncludingDeleted(
          where: (listing) => deckIds.contains(listing.deckId),
        ),
        action:
            'selectManyByDeckIdsIncludingDeleted(${deckIds.length} deckIds)',
      );

  List<DeckListing> selectManyIncludingDeleted({
    bool Function(DeckListing item)? where,
    int? limit,
    int offset = 0,
  }) => selectMany(
    where: where,
    limit: limit,
    offset: offset,
    includeDeleted: true,
  );

  List<SyncIndexEntry> selectSyncIndexByDeckIds(Set<String> deckIds) =>
      selectSyncIndexWhere(
        where: (listing) => deckIds.contains(listing.deckId),
        getId: (listing) => listing.deckId,
        getUpdatedAt: (listing) => listing.updatedAt,
        action: 'selectSyncIndexByDeckIds(${deckIds.length} deckIds)',
      );

  // ── All standard CRUD (put, getById, delete, etc.) is inherited! ──
}
