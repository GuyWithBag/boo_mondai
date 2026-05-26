// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/services/supabase/deck_listing_remote.db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show SupabaseRemoteDB, DeckListing, DeckListingMapper;

class DeckListingsRemoteDB extends SupabaseRemoteDB<DeckListing> {
  @override
  String get tableName => 'deck_listings';

  @override
  DeckListing Function(Map<String, dynamic>) get fromMap =>
      DeckListingMapper.fromMap;

  @override
  Map<String, dynamic> toMap(DeckListing item) => item.toMap();

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

  /// Updates the Listing.
  /// RLS ensures only the deck owner can successfully execute this.
  Future<DeckListing> updateListing(DeckListing listing) => guard(() async {
    // Convert the entire DTO to a map
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
