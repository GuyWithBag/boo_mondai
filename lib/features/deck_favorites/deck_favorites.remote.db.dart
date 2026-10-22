import 'package:boo_mondai/lib.barrel.dart'
    show SupabaseRemoteDB, DeckFavorite, DeckFavoriteMapper;

const _deckFavoriteWithRelationsSelect =
    '*, deck:decks(*, user_profile:profiles!decks_user_id_fkey(id, username, avatar_url, created_at), listing:deck_listings(*), tags(*)), user_profile:profiles!deck_favorites_user_id_fkey(id, username, avatar_url, created_at)';

// ToDo: Remove this and use bookmarks instead.
class DeckFavoritesRemoteDB extends SupabaseRemoteDB<DeckFavorite> {
  @override
  String get tableName => 'deck_favorites';

  @override
  DeckFavorite Function(Map<String, dynamic>) get fromMap =>
      DeckFavoriteMapper.fromMap;

  @override
  Map<String, dynamic> toMap(DeckFavorite item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(DeckFavorite item) => {
    'deck_id': item.deckId,
    'profile_id': item.profileId,
  };

  @override
  String get upsertConflictTarget => 'deck_id,profile_id';

  @override
  String get defaultSelect => _deckFavoriteWithRelationsSelect;

  Future<DeckFavorite?> getByDeckAndUser({
    required String deckId,
    required String profileId,
  }) => selectOne(filters: {'deck_id': deckId, 'profile_id': profileId});

  Future<List<DeckFavorite>> getByUser(String profileId) => selectMany(
    filters: {'profile_id': profileId},
    orderBy: 'created_at',
    ascending: false,
  );
}
