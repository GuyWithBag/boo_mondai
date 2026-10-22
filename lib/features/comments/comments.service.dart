import 'package:boo_mondai/lib.barrel.dart'
    show
        Comment,
        CommentEditLog,
        RemoteDB,
        Content,
        DiscussionsService,
        JoinedComment;
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentsService implements DiscussionsService {
  static Future<List<Comment>> getByDeck(String deckId) =>
      RemoteDB.comments.getByDeck(deckId);

  static Future<List<CommentEditLog>> getEditLogs(Comment comment) =>
      RemoteDB.commentEditLogs.getByComment(comment);

  static Future<void> add({
    required Comment comment,
    required Content content,
  }) async {
    await RemoteDB.comments.upsert(comment.copyWith(body: comment.body.trim()));
    await RemoteDB.contents.upsert(content);
  }

  static Future<int> getReplyCount(Content commentContent) async {
    final response = await RemoteDB.comments.query
        .select('id, contents!inner(parent_content_id)')
        .eq('contents.parent_content_id', commentContent.id)
        .count(CountOption.exact);

    return response.count;
  }

  static Future<List<JoinedComment>> getReplies(Content commentContent) async {
    final response = await RemoteDB.comments.query
        .select('*, contents!inner(*)')
        .eq('contents.parent_content_id', commentContent.id);

    return List<Map<String, dynamic>>.from(response).map((row) {
      return (
        comment: RemoteDB.comments.fromMap(row),
        content: RemoteDB.contents.fromMap(row['contents']),
      );
    }).toList();
  }

  static Future<void> upsert({
    required Comment comment,
    required String body,
  }) async {
    final trimmedBody = body.trim();
    if (trimmedBody.isEmpty) return;

    await RemoteDB.comments.upsert(comment);
  }
}
