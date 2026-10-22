import 'package:boo_mondai/lib.barrel.dart'
    show
        Comment,
        CommentWithDepth,
        CommentsService,
        Content,
        ProfileService,
        RemoteDB;
import 'package:signals/signals_flutter.dart';

class ViewCommentsController {
  ViewCommentsController(Content rootContent) {
    loadRoot(rootContent);
  }

  late final comments = listSignal<CommentWithDepth<Comment>>([]);

  Future<void> loadRoot(Content rootContent) async {
    comments.value = await getRepliesByContent(rootContent, depth: 0);
  }

  Future<void> expandReplies({
    required Content parentContent,
    required int parentIndex,
    required int depth,
  }) async {
    final replies = await getRepliesByContent(parentContent, depth: depth);
    comments.insertAll(parentIndex + 1, replies);
  }

  Future<List<CommentWithDepth<Comment>>> getRepliesByContent(
    Content parentContent, {
    required int depth,
  }) async {
    final replies = await CommentsService.getReplies(parentContent);

    return Future.wait(
      replies.indexed.map((entry) async {
        final (index, reply) = entry;
        final profile =
            await RemoteDB.profile.selectOne(
              filters: {'id': reply.content.profileId},
            ) ??
            ProfileService.currentProfile.value;

        return CommentWithDepth<Comment>(
          content: reply.content,
          owner: reply.comment,
          depth: depth,
          order: index,
          profile: profile,
        );
      }),
    );
  }
}
