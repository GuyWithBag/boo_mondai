import 'package:boo_mondai/lib.barrel.dart'
    show SupabaseRemoteDB, ReviewEditLog, ReviewEditLogMapper, Review;

class ReviewEditLogsRemoteDB extends SupabaseRemoteDB<ReviewEditLog> {
  @override
  String get tableName => 'deck_vote_review_edit_logs';

  @override
  ReviewEditLog Function(Map<String, dynamic>) get fromMap =>
      ReviewEditLogMapper.fromMap;

  @override
  Map<String, dynamic> toMap(ReviewEditLog item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(ReviewEditLog item) => {
    'id': item.id,
  };

  @override
  String get defaultSelect => _deckVoteReviewEditLogWithRelationsSelect;

  Future<List<ReviewEditLog>> getByReview(Review review) => guard(() async {
    final response = await query
        .select(defaultSelect)
        .eq('review_id', review.id)
        .order('edited_at', ascending: false);

    return response.map(fromMap).toList();
  }, action: 'getByReview(${review.id})');
}

const _deckVoteReviewEditLogWithRelationsSelect =
    '*, editor_profile:profiles!deck_vote_review_edit_logs_edited_by_fkey(id, username, avatar_url, created_at)';
