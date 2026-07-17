// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/remote/deck_remote_db.dart
// PURPOSE: Supabase CRUD for decks
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        SupabaseRemoteDB,
        Deck,
        SyncIndexEntry,
        DeckSortField,
        SearchSortDirection,
        DeckMapper,
        ImageHelper;

class DecksRemoteDB extends SupabaseRemoteDB<Deck> {
  @override
  String get tableName => 'decks';

  @override
  Deck Function(Map<String, dynamic>) get fromMap => DeckMapper.fromMap;

  @override
  Map<String, dynamic> toMap(Deck item) {
    final map = item.toMap();
    final coverImageUrl = item.coverImageUrl;
    if (coverImageUrl != null && !ImageHelper.isRemoteUrl(coverImageUrl)) {
      map['cover_image_url'] = null;
    }
    return map;
  }

  @override
  Map<String, Object?> primaryKeyFromItem(Deck item) => {'id': item.id};

  @override
  String get upsertConflictTarget => 'id';

  @override
  bool get supportsSoftDelete => true;

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
      final firstListing = listing.isEmpty
          ? null
          : Map<String, dynamic>.from(listing.first as Map);
      map['listing'] =
          firstListing == null || firstListing['deleted_at'] != null
          ? null
          : firstListing;
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

  Future<Deck?> selectById(String deckId, {bool includeDeleted = false}) =>
      selectOne(filters: {'id': deckId}, includeDeleted: includeDeleted);

  Future<List<Deck>> selectManyByIds(
    List<String> ids, {
    bool includeDeleted = false,
  }) async {
    final decks = <Deck>[];
    for (final id in ids) {
      final deck = await selectById(id, includeDeleted: includeDeleted);
      if (deck != null) decks.add(deck);
    }
    return decks;
  }

  Future<List<Deck>> selectManyByUserId(String profileId) => selectMany(
    filters: {'user_id': profileId},
    orderBy: 'updated_at',
    ascending: false,
  );

  Future<List<Deck>> selectManyByUserIdAndOptionalDeckId({
    required String userId,
    String? deckId,
  }) async {
    if (deckId != null) {
      final deck = await selectById(deckId);
      return deck == null ? const [] : [deck];
    }
    return selectManyByUserId(userId);
  }

  Future<List<SyncIndexEntry>> selectSyncIndexByUserIdAndOptionalDeckId({
    required String userId,
    String? deckId,
  }) => selectSyncIndex(
    applyQuery: (query) =>
        applyFilters(query, {'user_id': userId, 'id': ?deckId}),
    action: 'selectSyncIndexByUserIdAndOptionalDeckId($userId, $deckId)',
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
