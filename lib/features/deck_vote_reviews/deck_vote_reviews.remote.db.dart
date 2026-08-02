import 'package:boo_mondai/lib.barrel.dart'
    show
        DeckVoteReview,
        DeckVoteReviewComment,
        DeckVoteReviewCommentEditLog,
        DeckVoteReviewCommentEditLogMapper,
        DeckVoteReviewCommentMapper,
        DeckVoteReviewEditLog,
        DeckVoteReviewEditLogMapper,
        DeckVoteReviewMapper,
        SupabaseRemoteDB;

class DeckVoteReviewsRemoteDB extends SupabaseRemoteDB<DeckVoteReview> {
  @override
  String get tableName => 'deck_vote_reviews';

  @override
  DeckVoteReview Function(Map<String, dynamic>) get fromMap =>
      DeckVoteReviewMapper.fromMap;

  @override
  Map<String, dynamic> toMap(DeckVoteReview item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(DeckVoteReview item) => {
    'id': item.id,
  };

  @override
  String get upsertConflictTarget => 'deck_id,user_id';

  @override
  String get defaultSelect => _deckVoteReviewWithRelationsSelect;

  @override
  Set<String> get joinedFields => const {'userProfile', 'user_profile'};

  Future<List<DeckVoteReview>> getByDeck(String deckId) => selectMany(
    filters: {'deck_id': deckId, 'is_deleted': false},
    orderBy: 'created_at',
    ascending: false,
  );

  Future<DeckVoteReview?> getByDeckAndUser({
    required String deckId,
    required String profileId,
  }) => selectOne(filters: {'deck_id': deckId, 'profile_id': profileId});
}

class DeckVoteReviewEditLogsRemoteDB
    extends SupabaseRemoteDB<DeckVoteReviewEditLog> {
  @override
  String get tableName => 'deck_vote_review_edit_logs';

  @override
  DeckVoteReviewEditLog Function(Map<String, dynamic>) get fromMap =>
      DeckVoteReviewEditLogMapper.fromMap;

  @override
  Map<String, dynamic> toMap(DeckVoteReviewEditLog item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(DeckVoteReviewEditLog item) => {
    'id': item.id,
  };

  @override
  String get defaultSelect => _deckVoteReviewEditLogWithRelationsSelect;

  @override
  Set<String> get joinedFields => const {'editorProfile', 'editor_profile'};

  Future<List<DeckVoteReviewEditLog>> getByReview(String reviewId) =>
      selectMany(
        filters: {'review_id': reviewId},
        orderBy: 'edited_at',
        ascending: false,
      );
}

class DeckVoteReviewCommentsRemoteDB
    extends SupabaseRemoteDB<DeckVoteReviewComment> {
  @override
  String get tableName => 'deck_vote_review_comments';

  @override
  DeckVoteReviewComment Function(Map<String, dynamic>) get fromMap =>
      DeckVoteReviewCommentMapper.fromMap;

  @override
  Map<String, dynamic> toMap(DeckVoteReviewComment item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(DeckVoteReviewComment item) => {
    'id': item.id,
  };

  @override
  String get defaultSelect => _deckVoteReviewCommentWithRelationsSelect;

  @override
  Set<String> get joinedFields => const {'userProfile', 'user_profile'};

  Future<List<DeckVoteReviewComment>> getByReview(String reviewId) =>
      selectMany(
        filters: {'review_id': reviewId, 'is_deleted': false},
        orderBy: 'created_at',
      );
}

class DeckVoteReviewCommentEditLogsRemoteDB
    extends SupabaseRemoteDB<DeckVoteReviewCommentEditLog> {
  @override
  String get tableName => 'deck_vote_review_comment_edit_logs';

  @override
  DeckVoteReviewCommentEditLog Function(Map<String, dynamic>) get fromMap =>
      DeckVoteReviewCommentEditLogMapper.fromMap;

  @override
  Map<String, dynamic> toMap(DeckVoteReviewCommentEditLog item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(DeckVoteReviewCommentEditLog item) =>
      {'id': item.id};

  @override
  String get defaultSelect => _deckVoteReviewCommentEditLogWithRelationsSelect;

  @override
  Set<String> get joinedFields => const {'editorProfile', 'editor_profile'};

  Future<List<DeckVoteReviewCommentEditLog>> getByComment(String commentId) =>
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
