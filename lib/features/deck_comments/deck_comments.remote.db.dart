import 'package:boo_mondai/lib.barrel.dart'
    show
        DeckComment,
        DeckCommentEditLog,
        DeckCommentEditLogMapper,
        DeckCommentMapper,
        SupabaseRemoteDB;

class DeckCommentsRemoteDB extends SupabaseRemoteDB<DeckComment> {
  @override
  String get tableName => 'deck_comments';

  @override
  DeckComment Function(Map<String, dynamic>) get fromMap =>
      DeckCommentMapper.fromMap;

  @override
  Map<String, dynamic> toMap(DeckComment item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(DeckComment item) => {'id': item.id};

  @override
  String get defaultSelect => _deckCommentWithRelationsSelect;

  @override
  Set<String> get joinedFields => const {'userProfile', 'user_profile'};

  Future<List<DeckComment>> getByDeck(String deckId) => selectMany(
    filters: {'deck_id': deckId, 'is_deleted': false},
    orderBy: 'created_at',
  );
}

class DeckCommentEditLogsRemoteDB extends SupabaseRemoteDB<DeckCommentEditLog> {
  @override
  String get tableName => 'deck_comment_edit_logs';

  @override
  DeckCommentEditLog Function(Map<String, dynamic>) get fromMap =>
      DeckCommentEditLogMapper.fromMap;

  @override
  Map<String, dynamic> toMap(DeckCommentEditLog item) => item.toMap();

  @override
  Map<String, Object?> primaryKeyFromItem(DeckCommentEditLog item) => {
    'id': item.id,
  };

  @override
  String get defaultSelect => _deckCommentEditLogWithRelationsSelect;

  @override
  Set<String> get joinedFields => const {'editorProfile', 'editor_profile'};

  Future<List<DeckCommentEditLog>> getByComment(String commentId) => selectMany(
    filters: {'comment_id': commentId},
    orderBy: 'edited_at',
    ascending: false,
  );
}

const _deckCommentWithRelationsSelect =
    '*, user_profile:profiles!deck_comments_user_id_fkey(id, username, avatar_url, created_at)';

const _deckCommentEditLogWithRelationsSelect =
    '*, editor_profile:profiles!deck_comment_edit_logs_edited_by_fkey(id, username, avatar_url, created_at)';
