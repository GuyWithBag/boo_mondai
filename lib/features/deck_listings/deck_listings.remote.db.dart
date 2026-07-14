// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/deck_listing_remote.db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        SupabaseRemoteDB,
        DeckListing,
        DeckListingMapper,
        ImageHelper,
        SyncIndexEntry;

class DeckListingsRemoteDB extends SupabaseRemoteDB<DeckListing> {
  @override
  String get tableName => 'deck_listings';

  @override
  DeckListing Function(Map<String, dynamic>) get fromMap =>
      DeckListingMapper.fromMap;

  @override
  Map<String, dynamic> toMap(DeckListing item) {
    final map = item.toMap();
    map['featured_images'] = item.featuredImages
        .where(ImageHelper.isRemoteUrl)
        .toList(growable: false);
    return map;
  }

  @override
  Map<String, Object?> primaryKeyFromItem(DeckListing item) => {
    'deck_id': item.deckId,
  };

  @override
  String get upsertConflictTarget => 'deck_id';

  // ── Custom Queries ──────────────────────────────────────────────

  /// Fetches a specific listing by its Deck ID.
  /// (Overrides standard selectById since the column is 'deck_id')
  Future<DeckListing?> getByDeckId(String deckId) =>
      selectOne(filters: {'deck_id': deckId});

  Future<List<DeckListing>> selectManyByDeckIds(List<String> deckIds) async {
    final listings = <DeckListing>[];
    for (final deckId in deckIds) {
      final listing = await getByDeckId(deckId);
      if (listing != null) listings.add(listing);
    }
    return listings;
  }

  Future<List<SyncIndexEntry>> selectSyncIndexByDeckIds(List<String> deckIds) =>
      guard(() async {
        if (deckIds.isEmpty) return const <SyncIndexEntry>[];

        final response = await client
            .from(tableName)
            .select('deck_id, updated_at')
            .inFilter('deck_id', deckIds);
        return List<Map<String, dynamic>>.from(response)
            .map(
              (row) => SyncIndexEntry(
                id: row['deck_id'] as String,
                updatedAt: DateTime.parse(row['updated_at'] as String),
              ),
            )
            .toList(growable: false);
      }, action: 'selectSyncIndexByDeckIds(${deckIds.length} deckIds)');

  Future<SyncIndexEntry?> selectSyncIndexByDeckId(String deckId) =>
      guard(() async {
        final row = await client
            .from(tableName)
            .select('deck_id, updated_at')
            .eq('deck_id', deckId)
            .maybeSingle();
        if (row == null) return null;
        return SyncIndexEntry(
          id: row['deck_id'] as String,
          updatedAt: DateTime.parse(row['updated_at'] as String),
        );
      }, action: 'selectSyncIndexByDeckId($deckId)');

  /// Updates the Listing.
  /// RLS ensures only the deck owner can successfully execute this.
  Future<DeckListing> updateListing(DeckListing listing) => guard(() async {
    // Convert the entire MutableEntity to a map
    final updates = toMap(listing);

    // Ensure the timestamp is fresh
    updates['updated_at'] = DateTime.now().toUtc().toIso8601String();

    // Remove the primary key from the update payload to prevent DB errors
    updates.remove('deck_id');

    final response = await client
        .from(tableName)
        .update(updates)
        .eq('deck_id', listing.deckId)
        .select()
        .single();

    return fromMap(response);
  }, action: 'updateListing(${listing.deckId})');
}
