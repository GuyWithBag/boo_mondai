// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/local/deck_listing_local.db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        Content,
        DeckListing,
        HiveLocalDB,
        HivePrimaryKey,
        SyncIndexEntry,
        LocalDB;

class DeckListingsLocalDB extends HiveLocalDB<DeckListing> {
  @override
  String get boxName => 'deck_listings';

  @override
  Map<String, Object?> primaryKeyFromItem(DeckListing item) => {
    'deck_id': item.deckId,
  };

  @override
  DateTime? getDeletedAt(DeckListing item) {
    return LocalDB.contents.selectByPk({
      'id': item.contentId,
    }, includeDeleted: true)?.deletedAt;
  }

  DeckListing? selectByPkIncludingDeleted(HivePrimaryKey primaryKey) {
    return selectByPk(primaryKey, includeDeleted: true);
  }

  Content? getContentByListing(
    DeckListing listing, {
    bool includeDeleted = false,
  }) => guardSync(
    () => LocalDB.contents.selectByPk({
      'id': listing.contentId,
    }, includeDeleted: includeDeleted),
    action: 'getContentByListing(${listing.deckId})',
  );

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
      guardSync(() {
        return box.values
            .where((listing) => deckIds.contains(listing.deckId))
            .map((listing) {
              final content = LocalDB.contents.selectByPk({
                'id': listing.contentId,
              }, includeDeleted: true);

              if (content == null) return null;

              return SyncIndexEntry(
                id: listing.deckId,
                updatedAt: content.updatedAt,
              );
            })
            .nonNulls
            .toList(growable: false);
      }, action: 'selectSyncIndexByDeckIds(${deckIds.length} deckIds)');

  // ── All standard CRUD (put, getById, delete, etc.) is inherited! ──
}
