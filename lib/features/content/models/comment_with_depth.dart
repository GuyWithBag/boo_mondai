import 'package:boo_mondai/lib.barrel.dart' show Content, Profile, Comment;

class CommentWithDepth<T extends Comment> {
  final Content content;
  final T owner;
  final Profile profile;
  final int depth;
  final int order;

  CommentWithDepth({
    required this.content,
    required this.owner,
    required this.depth,
    required this.order,
    required this.profile,
  });
}
