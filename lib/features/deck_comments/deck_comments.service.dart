import 'package:boo_mondai/lib.barrel.dart'
    show DeckComment, DeckCommentEditLog, RemoteDB, uuid;

class DeckCommentsService {
  const DeckCommentsService._();

  static Future<List<DeckComment>> getByDeck(String deckId) =>
      RemoteDB.deckComment.getByDeck(deckId);

  static Future<List<DeckCommentEditLog>> getEditLogs(String commentId) =>
      RemoteDB.deckCommentEditLog.getByComment(commentId);

  static Future<void> addComment({
    required String deckId,
    required String userId,
    required String body,
    String? parentCommentId,
  }) async {
    final trimmedBody = body.trim();
    if (trimmedBody.isEmpty) return;

    final comment = DeckComment.createNow(
      id: uuid.v7(),
      deckId: deckId,
      userId: userId,
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
