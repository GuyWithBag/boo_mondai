// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/database/remote/deck_remote_db.dart
// PURPOSE: Supabase CRUD for decks
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        SupabaseRemoteDB,
        ContentMapper,
        Deck,
        DeckListingMapper,
        SyncIndexEntry,
        DeckSortField,
        SearchSortDirection,
        ProfileMapper,
        LocalDB,
        DeckMapper,
        DeckWithListingContent;

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
  bool get supportsSoftDelete => true;

  @override
  String get defaultSelect =>
      '*, user_profile:profiles!decks_user_id_fkey(id, username, avatar_url, created_at), listing:deck_listings(*), tags(*)';

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

  Future<DeckWithListingContent?> selectWithListingContentById(
    String deckId, {
    bool includeDeleted = false,
  }) => guard(() async {
    const deckListingContentSelect = '''
      *,
      profiles!inner(
        id,
        username,
        avatar_url,
        created_at
      ),
      deck_listings!inner(
        *,
        contents!inner(*)
      ),
      tags(*)
    ''';

    var query = client.from(tableName).select(deckListingContentSelect);
    query = applySoftDeleteFilter(query, includeDeleted: includeDeleted);

    final response = await query.eq('id', deckId).maybeSingle();
    if (response == null) return null;

    final deck = fromMap(response);
    final listing = DeckListingMapper.fromMap(response['deck_listings']);

    final content = ContentMapper.fromMap(
      response['deck_listings']['contents'],
    );

    final profile = ProfileMapper.fromMap(response['profiles']);
    final cachedProfile = LocalDB.profiles.selectByPk({'id': profile.id});

    return (
      deck: deck,
      deckListing: listing,
      deckListingContent: content,
      profile: cachedProfile ?? profile,
      // ToDo: fix
      sourceProfile: null,
    );
  }, action: 'selectWithListingContentById($deckId)');

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
    filters: {'profile_id': profileId},
    orderBy: 'updated_at',
    ascending: false,
  );

  Future<List<Deck>> selectManyByUserIdAndOptionalDeckId({
    required String profileId,
    String? deckId,
  }) async {
    if (deckId != null) {
      final deck = await selectById(deckId);
      return deck == null ? const [] : [deck];
    }
    return selectManyByUserId(profileId);
  }

  Future<List<SyncIndexEntry>> selectSyncIndexByProfileIdAndOptionalDeckId({
    required String profileId,
    String? deckId,
  }) => selectSyncIndex(
    applyQuery: (query) {
      query = query.eq('profile_id', profileId);
      if (deckId != null) {
        query = query.eq('id', deckId);
      }
      return query;
    },
    action: 'selectSyncIndexByProfileIdAndOptionalDeckId($profileId, $deckId)',
  );

  String _columnForSortField(DeckSortField field) {
    return switch (field) {
      DeckSortField.letters => 'title',
      DeckSortField.createdAt => 'created_at',
      DeckSortField.updatedAt => 'updated_at',
    };
  }
}
