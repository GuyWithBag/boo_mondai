import 'package:boo_mondai/lib.barrel.dart'
    show
        ViewDeckListingSingleController,
        AppTokens,
        SectionEyebrow,
        DiscussionTile,
        DiscussionComposerTile,
        DiscussionType;
import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Widget,
        BuildContext,
        Center,
        SizedBox,
        CrossAxisAlignment,
        CircularProgressIndicator,
        Text,
        Column;

import 'package:theme_variants/theme_variants.dart' show ThemeVariantsContext;

class DiscussionSection extends StatelessWidget {
  const DiscussionSection({super.key, required this.sheet});

  final ViewDeckListingSingleController sheet;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionEyebrow('Reviews'),
        SizedBox(height: tokens.spaceLayoutGapMd),
        DiscussionComposerTile(
          type: DiscussionType.review,
          isSubmitting: sheet.isSubmittingReview,
          onReviewSubmitted: sheet.submitReview,
        ),
        SizedBox(height: tokens.spaceLayoutGapLg),
        if (sheet.isLoadingDiscussion)
          const Center(child: CircularProgressIndicator())
        else if (sheet.reviewItems.isEmpty)
          Text('No reviews yet.')
        else
          for (final review in sheet.reviewItems)
            DiscussionTile(
              item: review,
              repliesFor: sheet.reviewRepliesFor,
              onReply: sheet.replyToReview,
              onEdit: sheet.editReview,
              canEdit: sheet.canEditReviewItem,
              isSubmitting:
                  sheet.isSubmittingReview || sheet.isSubmittingReviewComment,
            ),
        SizedBox(height: tokens.spaceLayoutGapLg),
        SectionEyebrow('Comments'),
        SizedBox(height: tokens.spaceLayoutGapMd),
        DiscussionComposerTile(
          type: DiscussionType.comment,
          isSubmitting: sheet.isSubmittingComment,
          onCommentSubmitted: sheet.submitComment,
        ),
        SizedBox(height: tokens.spaceLayoutGapLg),
        if (sheet.isLoadingDiscussion)
          const SizedBox.shrink()
        else if (sheet.commentItems.isEmpty)
          Text('No comments yet.')
        else
          for (final comment in sheet.commentItems)
            DiscussionTile(
              item: comment,
              repliesFor: sheet.commentRepliesFor,
              onReply: sheet.submitComment,
              onEdit: sheet.editComment,
              canEdit: sheet.canEditCommentItem,
              isSubmitting: sheet.isSubmittingComment,
            ),
      ],
    );
  }
}
