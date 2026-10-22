import 'package:boo_mondai/lib.barrel.dart'
    show
        ViewCommentsController,
        Comment,
        CommentWithDepth,
        CommentsService,
        DiscussionTileController,
        DiscussionTile,
        Button;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_hooks/signals_hooks.dart';

class ViewCommentsTile extends SignalHookWidget {
  const ViewCommentsTile({
    super.key,
    required this.controller,
    required this.index,
    required this.item,
  });

  final ViewCommentsController controller;
  final int index;
  final CommentWithDepth<Comment> item;

  @override
  Widget build(BuildContext context) {
    final replyCountFuture = useMemoized(
      () => CommentsService.getReplyCount(item.content),
      [item.content.id],
    );
    final replyCountSnapshot = useFuture(replyCountFuture);
    final isExpanded = useSignal(false);
    final isLoadingReplies = useSignal(false);
    final replyCount = replyCountSnapshot.data ?? 0;

    return Column(
      children: [
        DiscussionTile(
          controller: DiscussionTileController(item: item, depth: item.depth),
        ),
        if (!isExpanded.value && replyCount > 0)
          Button(
            onPressed: isLoadingReplies.value
                ? null
                : () async {
                    isLoadingReplies.value = true;
                    try {
                      await controller.expandReplies(
                        parentContent: item.content,
                        parentIndex: index,
                        depth: item.depth + 1,
                      );
                      isExpanded.value = true;
                    } finally {
                      isLoadingReplies.value = false;
                    }
                  },
            child: Text('View replies $replyCount'),
          ),
      ],
    );
  }
}
