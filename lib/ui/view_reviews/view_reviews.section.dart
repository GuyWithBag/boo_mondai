import 'package:boo_mondai/lib.barrel.dart'
    show
        Comment,
        Content,
        ListingStatesWrapper,
        ViewReviewsController,
        ViewReviewsTile,
        uuid;
import 'package:boo_mondai/ui/ui.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals/signals_hooks.dart';

class ViewReviewsSection extends SignalHookWidget {
  const ViewReviewsSection({super.key, required this.rootContent});

  final Content rootContent;

  @override
  Widget build(BuildContext context) {
    final controller = useMemoized(() => ViewReviewsController(rootContent));

    return ListingStatesWrapper.list(
      items: controller.comments,
      leadingItem: DiscussionComposerTile(
        controller: DiscussionComposerController(
          initComment: Comment(
            contentId: '',
            deletedAt: DateTime.now(),
            id: uuid.v7(),
            body: '',
          ),
        ),
      ),
      itemBuilder: (context, index, item) =>
          ViewReviewsTile(controller: controller, index: index, item: item),
    );
  }
}
