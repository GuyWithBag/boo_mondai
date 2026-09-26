import 'package:boo_mondai/lib.barrel.dart'
    show Review, ReviewMapper, SupabaseRemoteDB;

class ReviewsRemoteDB extends SupabaseRemoteDB<Review> {
  @override
  String get tableName => 'reviews';

  @override
  Review Function(Map<String, dynamic>) get fromMap => ReviewMapper.fromMap;

  @override
  Map<String, dynamic> toMap(Review item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(Review item) => {'id': item.id};

  @override
  String get upsertConflictTarget => 'deck_id,profile_id';

  @override
  String get defaultSelect => _deckVoteReviewWithRelationsSelect;

  Future<List<Review>> getByDeck(String deckId) => selectMany(
    filters: {'deck_id': deckId, 'is_deleted': false},
    orderBy: 'created_at',
    ascending: false,
  );

  Future<Review?> getByDeckAndUser({
    required String deckId,
    required String profileId,
  }) => selectOne(filters: {'deck_id': deckId, 'profile_id': profileId});
}

const _deckVoteReviewWithRelationsSelect =
    '*, user_profile:profiles!deck_vote_reviews_user_id_fkey(id, username, avatar_url, created_at)';
