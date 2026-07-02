import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonVariant,
        DiscussionEditCallback,
        DiscussionItem,
        DiscussionLikeCallback,
        DiscussionPermission,
        DiscussionRepliesFor,
        DiscussionReplyCallback,
        MarkdownText,
        MarkdownTextMode,
        MetaLabel,
        ProfileLabel,
        surfaceStyle,
        useDiscussionTileController,
        SurfaceBorder,
        SurfaceShape,
        SurfacePadding;
import 'package:flutter/material.dart'
    show
        Align,
        Alignment,
        BoxConstraints,
        BuildContext,
        CircularProgressIndicator,
        Column,
        ConstrainedBox,
        CrossAxisAlignment,
        EdgeInsets,
        Icon,
        Icons,
        MainAxisAlignment,
        MainAxisSize,
        Padding,
        Row,
        SelectableText,
        Text,
        TextInputAction,
        Widget;
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget;
import 'package:theme_variants/theme_variants.dart'
    show ThemeVariantsContext, Surface;

class DiscussionTile extends HookWidget {
  const DiscussionTile({
    super.key,
    required this.item,
    required this.repliesFor,
    this.onReply,
    this.onEdit,
    this.onLike,
    this.canEdit,
    this.isSubmitting = false,
    this.depth = 0,
  });

  final DiscussionItem item;
  final DiscussionRepliesFor repliesFor;
  final DiscussionReplyCallback? onReply;
  final DiscussionEditCallback? onEdit;
  final DiscussionLikeCallback? onLike;
  final DiscussionPermission? canEdit;
  final bool isSubmitting;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final controller = useDiscussionTileController(
      item: item,
      repliesFor: repliesFor,
      onReply: onReply,
      onEdit: onEdit,
      onLike: onLike,
      canEdit: canEdit,
    );

    final tokens = context.themeTokens<AppTokens>();
    final isNested = depth > 0;
    final wasEdited =
        item.updatedAt.difference(item.createdAt).abs() >
        const Duration(seconds: 1);
    final isEditingDiscussion = controller.isEditing;
    final isReplyingToDiscussion = controller.isReplying;
    final isLikeSubmitting = controller.isLikeSubmitting;
    final isReview = controller.item.isReview;
    final isDeletedDiscussion = item.isDeleted;
    final shouldDisplayEditTitleField = isEditingDiscussion.value && isReview;
    final shouldDisplayReviewTitle =
        isReview && !isDeletedDiscussion && (item.title ?? '').isNotEmpty;
    final shouldDisplayDeletedDiscussionMessage = isDeletedDiscussion;
    final shouldDisplayReplyAction = controller.canReply;
    final shouldDisplayEditAction = controller.canEditItem;
    final shouldDisplayLikeAction = isReview && controller.onLike != null;
    final shouldDisableLikeAction = isSubmitting || isLikeSubmitting.value;
    final editBodyPlaceholder = isReview ? 'Update review' : 'Update comment';
    final deletedDiscussionLabel = isReview ? 'review' : 'comment';

    return Padding(
      padding: EdgeInsets.only(left: isNested ? tokens.spaceLayoutGapLg : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: tokens.spaceLayoutGapSm,
        children: [
          // Header: author + dates
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: tokens.spaceLayoutGapSm,
            children: [
              ProfileLabel(
                label: 'By',
                displayName: item.userProfile?.username ?? 'Unknown author',
                avatarUrl: item.userProfile?.avatarUrl,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: tokens.spaceLayoutGapSm,
                children: [
                  MetaLabel(
                    label: _formatDate(item.createdAt),
                    icon: Icons.calendar_today_outlined,
                  ),
                  MetaLabel(
                    label: _formatDate(item.updatedAt),
                    icon: wasEdited
                        ? Icons.edit_calendar_outlined
                        : Icons.update,
                  ),
                ],
              ),
            ],
          ),

          // Body: editable or display
          if (isEditingDiscussion.value)
            Column(
              spacing: tokens.spaceLayoutGapSm,
              children: [
                if (shouldDisplayEditTitleField)
                  MarkdownText(
                    data: controller.editTitleController.text,
                    controller: controller.editTitleController,
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    placeholder: 'Review title',
                  ),
                MarkdownText(
                  data: controller.editBody.value,
                  onChanged: (value) => controller.editBody.value = value,
                  mode: MarkdownTextMode.input,
                  placeholder: editBodyPlaceholder,
                  maxLines: null,
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: tokens.spaceLayoutGapSm,
              children: [
                if (shouldDisplayReviewTitle)
                  Surface(
                    style: surfaceStyle.resolve(tokens, const [
                      SurfaceBorder.none,
                      SurfaceShape.roundedXsm,
                      SurfacePadding.sm,
                    ]),
                    child: MarkdownText(
                      data: item.title!,
                      mode: MarkdownTextMode.previewSelectable,
                    ),
                  ),
                Surface(
                  style: surfaceStyle.resolve(tokens, const [
                    SurfaceBorder.none,
                    SurfaceShape.roundedXsm,
                    SurfacePadding.sm,
                  ]),
                  child: shouldDisplayDeletedDiscussionMessage
                      ? SelectableText(
                          'This $deletedDiscussionLabel was deleted.',
                        )
                      : ConstrainedBox(
                          constraints: BoxConstraints(minHeight: 100),
                          child: MarkdownText(
                            data: item.body,
                            mode: MarkdownTextMode.previewSelectable,
                          ),
                        ),
                ),
              ],
            ),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: tokens.spaceLayoutGapSm,
            children: [
              if (isEditingDiscussion.value) ...[
                Button(
                  onPressed: isSubmitting ? null : controller.cancelEditing,
                  child: const Text('Cancel'),
                ),
                Button(
                  onPressed: isSubmitting ? null : controller.submitEdit,
                  leading: isSubmitting
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.check),
                  child: const Text('Save'),
                ),
              ] else ...[
                if (shouldDisplayReplyAction)
                  Button.icon(
                    icon: Icons.reply,
                    tokens: tokens,
                    onPressed: isSubmitting ? null : controller.toggleReplying,
                  ),
                if (shouldDisplayEditAction)
                  Button.icon(
                    icon: Icons.edit_outlined,
                    tokens: tokens,
                    onPressed: isSubmitting ? null : controller.startEditing,
                  ),
                if (shouldDisplayLikeAction)
                  Button.icon(
                    tokens: tokens,
                    icon: controller.item.isLiked
                        ? Icons.thumb_down_alt_outlined
                        : Icons.thumb_up_alt_outlined,
                    variant: ButtonVariant.flat,
                    onPressed: shouldDisableLikeAction
                        ? null
                        : controller.submitLike,
                  ),
              ],
            ],
          ),

          // Reply composer
          if (isReplyingToDiscussion.value)
            Column(
              spacing: tokens.spaceLayoutGapMd,
              children: [
                MarkdownText(
                  data: controller.replyBody.value,
                  onChanged: (value) => controller.replyBody.value = value,
                  mode: MarkdownTextMode.input,
                  placeholder: 'Write a reply',
                  maxLines: null,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Button(
                    onPressed: isSubmitting ? null : controller.submitReply,
                    leading: isSubmitting
                        ? const CircularProgressIndicator()
                        : const Icon(Icons.send_outlined),
                    child: const Text('Post Reply'),
                  ),
                ),
              ],
            ),

          // Nested replies
          for (final reply in controller.replies)
            DiscussionTile(
              item: reply,
              repliesFor: repliesFor,
              onReply: onReply,
              onEdit: onEdit,
              onLike: onLike,
              canEdit: canEdit,
              isSubmitting: isSubmitting,
              depth: depth + 1,
            ),
        ],
      ),
    );
  }
}

String _formatDate(DateTime value) {
  final local = value.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  final year = (local.year % 100).toString().padLeft(2, '0');
  return '$day-$month-$year';
}
