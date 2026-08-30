import 'package:boo_mondai/lib.barrel.dart'
    show Comment, SupabaseRemoteDB, CommentEditLog;

class CommentsRemoteDB extends SupabaseRemoteDB<Comment> {
  @override
  String get tableName => 'comments';

  @override
  Comment Function(Map<String, dynamic>) get fromMap => CommentMapper.fromMap;

  @override
  Map<String, dynamic> toMap(Comment item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(Comment item) => {'id': item.id};

  @override
  String get defaultSelect => _deckCommentWithRelationsSelect;

  @override
  Set<String> get joinedFields => const {'userProfile', 'user_profile'};

  Future<List<Comment>> getByDeck(String deckId) => selectMany(
    filters: {'deck_id': deckId, 'is_deleted': false},
    orderBy: 'created_at',
  );
}

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

  @override
  Set<String> get joinedFields => const {'editorProfile', 'editor_profile'};

  Future<List<CommentEditLog>> getByComment(String commentId) => selectMany(
    filters: {'comment_id': commentId},
    orderBy: 'edited_at',
    ascending: false,
  );
}

const _deckCommentWithRelationsSelect =
    '*, user_profile:profiles!comments_user_id_fkey(id, username, avatar_url, created_at)';

const _deckCommentEditLogWithRelationsSelect =
    '*, editor_profile:profiles!deck_comment_edit_logs_edited_by_fkey(id, username, avatar_url, created_at)';
