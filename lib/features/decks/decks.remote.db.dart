// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/remote/deck_remote_db.dart
// PURPOSE: Supabase CRUD for decks
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show SupabaseRemoteDB, Deck, DeckSortField, SearchSortDirection, DeckMapper;

class DecksRemoteDB extends SupabaseRemoteDB<Deck> {
  @override
  String get tableName => 'decks';

  @override
  Deck Function(Map<String, dynamic>) get fromMap => DeckMapper.fromMap;

  @override
  Map<String, dynamic> toMap(Deck item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(Deck item) => {'id': item.id};

  @override
  String get upsertConflictTarget => 'id';

  @override
  String get defaultSelect => _deckWithRelationsSelect;

  @override
  Set<String> get joinedFields => const {
    'userProfile',
    'user_profile',
    'listing',
    'tags',
  };

  @override
  Deck fromJoinedMap(Map<String, dynamic> map) {
    final listing = map['listing'];
    if (listing is List) {
      map['listing'] = listing.isEmpty ? null : listing.first;
    }

    return fromMap(map);
  }

  /// Fetches decks where visibility_state is 'public'.
  /// Also joins author, storefront listing data, and tags for the online browser.
  Future<List<Deck>> selectManyPublic({
    int? limit,
    int offset = 0,
    DeckSortField sortField = DeckSortField.createdAt,
    SearchSortDirection sortDirection = SearchSortDirection.descending,
  }) => selectMany(
    filters: const {'visibility_state': 'public', 'is_published': true},
    orderBy: _columnForSortField(sortField),
    ascending: sortDirection == SearchSortDirection.ascending,
    limit: limit,
    offset: offset,
  );

  Future<Deck?> selectById(String deckId) => selectOne(filters: {'id': deckId});

  Future<List<Deck>> selectManyByUserId(String profileId) => selectMany(
    filters: {'user_id': profileId},
    orderBy: 'updated_at',
    ascending: false,
  );

  String _columnForSortField(DeckSortField field) {
    return switch (field) {
      DeckSortField.letters => 'title',
      DeckSortField.createdAt => 'created_at',
      DeckSortField.updatedAt => 'updated_at',
    };
  }
}

const _deckWithRelationsSelect =
    '*, user_profile:profiles!decks_user_id_fkey(id, username, avatar_url, created_at), listing:deck_listings(*), tags(*)';
