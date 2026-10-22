import 'package:boo_mondai/lib.barrel.dart'
    show Comment, SupabaseRemoteDB, CommentMapper, Content;

typedef JoinedComment = ({Comment comment, Content content});

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

  Future<List<Comment>> getByDeck(String deckId) => selectMany(
    filters: {'deck_id': deckId, 'is_deleted': false},
    orderBy: 'created_at',
  );
}

const _deckCommentWithRelationsSelect =
    '*, user_profile:profiles!comments_user_id_fkey(id, username, avatar_url, created_at)';
