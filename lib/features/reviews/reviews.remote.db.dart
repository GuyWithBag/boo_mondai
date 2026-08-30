import 'package:boo_mondai/lib.barrel.dart'
    show
        Review,
        ReviewComment,
        ReviewCommentEditLog,
        ReviewCommentEditLogMapper,
        ReviewCommentMapper,
        ReviewEditLog,
        ReviewEditLogMapper,
        ReviewMapper,
        SupabaseRemoteDB;

class ReviewsRemoteDB extends SupabaseRemoteDB<Review> {
  @override
  String get tableName => 'deck_vote_reviews';

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

  @override
  Set<String> get joinedFields => const {'userProfile', 'user_profile'};

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

  @override
  Set<String> get joinedFields => const {'editorProfile', 'editor_profile'};

  Future<List<ReviewEditLog>> getByReview(String reviewId) => selectMany(
    filters: {'review_id': reviewId},
    orderBy: 'edited_at',
    ascending: false,
  );
}

class ReviewCommentsRemoteDB extends SupabaseRemoteDB<ReviewComment> {
  @override
  String get tableName => 'deck_vote_review_comments';

  @override
  ReviewComment Function(Map<String, dynamic>) get fromMap =>
      ReviewCommentMapper.fromMap;

  @override
  Map<String, dynamic> toMap(ReviewComment item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(ReviewComment item) => {
    'id': item.id,
  };

  @override
  String get defaultSelect => _deckVoteReviewCommentWithRelationsSelect;

  @override
  Set<String> get joinedFields => const {'userProfile', 'user_profile'};

  Future<List<ReviewComment>> getByReview(String reviewId) => selectMany(
    filters: {'review_id': reviewId, 'is_deleted': false},
    orderBy: 'created_at',
  );
}

class ReviewCommentEditLogsRemoteDB
    extends SupabaseRemoteDB<ReviewCommentEditLog> {
  @override
  String get tableName => 'deck_vote_review_comment_edit_logs';

  @override
  ReviewCommentEditLog Function(Map<String, dynamic>) get fromMap =>
      ReviewCommentEditLogMapper.fromMap;

  @override
  Map<String, dynamic> toMap(ReviewCommentEditLog item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(ReviewCommentEditLog item) => {
    'id': item.id,
  };

  @override
  String get defaultSelect => _deckVoteReviewCommentEditLogWithRelationsSelect;

  @override
  Set<String> get joinedFields => const {'editorProfile', 'editor_profile'};

  Future<List<ReviewCommentEditLog>> getByComment(String commentId) =>
      selectMany(
        filters: {'comment_id': commentId},
        orderBy: 'edited_at',
        ascending: false,
      );
}

const _deckVoteReviewWithRelationsSelect =
    '*, user_profile:profiles!deck_vote_reviews_user_id_fkey(id, username, avatar_url, created_at)';

const _deckVoteReviewEditLogWithRelationsSelect =
    '*, editor_profile:profiles!deck_vote_review_edit_logs_edited_by_fkey(id, username, avatar_url, created_at)';

const _deckVoteReviewCommentWithRelationsSelect =
    '*, user_profile:profiles!deck_vote_review_comments_user_id_fkey(id, username, avatar_url, created_at)';

const _deckVoteReviewCommentEditLogWithRelationsSelect =
    '*, editor_profile:profiles!deck_vote_review_comment_edit_logs_edited_by_fkey(id, username, avatar_url, created_at)';
