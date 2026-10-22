import 'package:boo_mondai/lib.barrel.dart'
    show CommentEditLog, CommentEditLogMapper, SupabaseRemoteDB, Comment;

class CommentEditLogsRemoteDB extends SupabaseRemoteDB<CommentEditLog> {
  @override
  String get tableName => 'deck_comment_edit_logs';

  @override
  CommentEditLog Function(Map<String, dynamic>) get fromMap =>
      CommentEditLogMapper.fromMap;

  @override
  Map<String, dynamic> toMap(CommentEditLog item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(CommentEditLog item) => {
    'id': item.id,
  };

  @override
  String get defaultSelect => _deckCommentEditLogWithRelationsSelect;

  Future<List<CommentEditLog>> getByComment(Comment comment) => selectMany(
    filters: {'comment_id': comment.id},
    orderBy: 'edited_at',
    ascending: false,
  );
}

const _deckCommentEditLogWithRelationsSelect =
    '*, editor_profile:profiles!deck_comment_edit_logs_edited_by_fkey(id, username, avatar_url, created_at)';
