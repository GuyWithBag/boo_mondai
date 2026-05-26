import 'package:boo_mondai/lib.barrel.dart'
    show
        DeckVoteReview,
        DeckVoteReviewComment,
        DeckVoteReviewCommentEditLog,
        DeckVoteReviewEditLog,
        RemoteDB,
        uuid;

class DeckVoteReviewsService {
  const DeckVoteReviewsService._();

  static Future<List<DeckVoteReview>> getByDeck(String deckId) =>
      RemoteDB.deckVoteReview.getByDeck(deckId);

  static Future<List<DeckVoteReviewEditLog>> getEditLogs(String reviewId) =>
      RemoteDB.deckVoteReviewEditLog.getByReview(reviewId);

  static Future<List<DeckVoteReviewComment>> getComments(String reviewId) =>
      RemoteDB.deckVoteReviewComment.getByReview(reviewId);

  static Future<List<DeckVoteReviewCommentEditLog>> getCommentEditLogs(
    String commentId,
  ) => RemoteDB.deckVoteReviewCommentEditLog.getByComment(commentId);

  static Future<void> upsertReview({
    required String deckId,
    required String userId,
    required int voteValue,
    required String title,
    required String body,
  }) async {
    final trimmedBody = body.trim();
    if (trimmedBody.isEmpty) return;

    final trimmedTitle = title.trim();
    await RemoteDB.deckInteractions.setVote(
      deckId: deckId,
      userId: userId,
      voteValue: voteValue,
    );

    final review = DeckVoteReview.createNow(
      id: uuid.v7(),
      deckId: deckId,
      userId: userId,
      voteValueAtCreation: voteValue,
      title: trimmedTitle,
      body: trimmedBody,
    );

    final existingReview = await RemoteDB.deckVoteReview.getByDeckAndUser(
      deckId: deckId,
      userId: userId,
    );
    if (existingReview == null) {
      await RemoteDB.deckVoteReview.insert(review);
      return;
    }

    await RemoteDB.deckVoteReview.updateWhere(
      filters: {'id': existingReview.id},
      values: {
        'vote_value_at_creation': voteValue,
        'title': trimmedTitle,
        'body': trimmedBody,
        'is_deleted': false,
        'updated_at': DateTime.now().toIso8601String(),
      },
    );
  }

  static Future<void> addComment({
    required String reviewId,
    required String userId,
    required String body,
    String? parentCommentId,
  }) async {
    final trimmedBody = body.trim();
    if (trimmedBody.isEmpty) return;

    final comment = DeckVoteReviewComment.createNow(
      id: uuid.v7(),
      reviewId: reviewId,
      userId: userId,
      parentCommentId: parentCommentId,
      body: trimmedBody,
    );
    await RemoteDB.deckVoteReviewComment.insert(comment);
  }

  static Future<void> updateComment({
    required String commentId,
    required String body,
  }) async {
    final trimmedBody = body.trim();
    if (trimmedBody.isEmpty) return;

    await RemoteDB.deckVoteReviewComment.updateWhere(
      filters: {'id': commentId},
      values: {
        'body': trimmedBody,
        'is_deleted': false,
        'updated_at': DateTime.now().toIso8601String(),
      },
    );
  }
}
