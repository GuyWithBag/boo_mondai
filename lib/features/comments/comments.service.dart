import 'package:boo_mondai/lib.barrel.dart'
    show Comment, CommentEditLog, RemoteDB, uuid;

class CommentsService {
  const CommentsService._();

  static Future<List<Comment>> getByDeck(String deckId) =>
      RemoteDB.deckComment.getByDeck(deckId);

  static Future<List<CommentEditLog>> getEditLogs(String commentId) =>
      RemoteDB.deckCommentEditLog.getByComment(commentId);

  static Future<void> addComment({
    required String deckId,
    required String profileId,
    required String body,
    String? parentCommentId,
  }) async {
    final trimmedBody = body.trim();
    if (trimmedBody.isEmpty) return;

    final comment = Comment.createNow(
      id: uuid.v7(),
      deckId: deckId,
      profileId: profileId,
      parentCommentId: parentCommentId,
      body: trimmedBody,
    );
    await RemoteDB.deckComment.insert(comment);
  }

  static Future<void> updateComment({
    required String commentId,
    required String body,
  }) async {
    final trimmedBody = body.trim();
    if (trimmedBody.isEmpty) return;

    await RemoteDB.deckComment.updateWhere(
      filters: {'id': commentId},
      values: {
        'body': trimmedBody,
        'is_deleted': false,
        'updated_at': DateTime.now().toIso8601String(),
      },
    );
  }
}
