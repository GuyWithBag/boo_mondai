import 'package:boo_mondai/lib.barrel.dart'
    show
        Button,
        CommentWithDepth,
        DiscussionTile,
        DiscussionTileController,
        Review,
        ViewCommentsSection,
        ViewReviewsController,
        textStyle,
        AppTokens,
        TextSize,
        ButtonVariant;
import 'package:flutter/material.dart';
import 'package:signals/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewReviewsTile extends SignalHookWidget {
  const ViewReviewsTile({
    super.key,
    required this.controller,
    required this.index,
    required this.item,
  });

  final ViewReviewsController controller;
  final int index;
  final CommentWithDepth<Review> item;

  @override
  Widget build(BuildContext context) {
    final showComments = useSignal(false);
    final tokens = context.themeTokens<AppTokens>();

    late final exception = useSignal<Exception?>(null);
    late final isLoading = useSignal(false);
    late final commentsCount = useSignal(0);

    final FutureSignal<int> commentsCountFuture = controller
        .getCommentsCount(item.content)
        .toFutureSignal();

    useSignalEffect(() {
      commentsCountFuture.value.map(
        error: (err, _) => exception.value = err,
        loading: () => isLoading.value = true,
        data: (count) {
          commentsCount.value = count;
          isLoading.value = false;
        },
      );
    });

    return Column(
      spacing: tokens.spaceLayoutGapSm,
      children: [
        DiscussionTile(
          controller: DiscussionTileController(item: item, depth: item.depth),
        ),
        if (commentsCount.value > 0)
          Button(
            variants: [ButtonVariant.text],
            onPressed: () => showComments.value = !showComments.value,
            child: Text(
              'View Comments ($commentsCount)',
              style: textStyle.resolve(tokens, const [TextSize.labelSmall]),
            ),
          ),
        if (showComments.value == true)
          ViewCommentsSection(rootContent: item.content),
      ],
    );
  }
}
