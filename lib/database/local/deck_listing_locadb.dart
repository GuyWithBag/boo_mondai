// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/local/deck_listing_local.db.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/database/database.barrel.dart';
import 'package:boo_mondai/models/models.barrel.dart';

class DeckListingLocalDB extends HiveLocalDB<DeckListing> {
  @override
  String get boxName => 'deck_listings';

  @override
  Map<String, Object?> primaryKeyFromItem(DeckListing item) => {
    'deck_id': item.deckId,
  };

  // ── All standard CRUD (put, getById, delete, etc.) is inherited! ──
}
