import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Content,
        ListingStatesWrapper,
        ViewCommentsController,
        ViewCommentsTile;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class ViewCommentsSection extends SignalHookWidget {
  const ViewCommentsSection({super.key, required this.rootContent});

  final Content rootContent;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final controller = useMemoized(() => ViewCommentsController(rootContent));

    useEffect(() {
      controller.loadRoot(rootContent);
      return null;
    }, [controller, rootContent.id]);

    return Column(
      children: [
        // DiscussionComposerTile(
        //   type: DiscussionType.comment,
        //   isSubmitting: sheet.isSubmittingComment,
        //   onCommentSubmitted: sheet.submitComment,
        // ),
        SizedBox(height: tokens.spaceLayoutGapLg),
        ListingStatesWrapper.list(
          items: controller.comments,
          itemBuilder: (context, index, item) => ViewCommentsTile(
            controller: controller,
            index: index,
            item: item,
          ),
        ),
      ],
    );
  }
}
