import 'package:boo_mondai/lib.barrel.dart'
    show
        MarkdownText,
        MarkdownTextMode,
        ProfileLabel,
        MetaLabel,
        Button,
        DiscussionRepliesFor,
        DiscussionItem,
        DiscussionReplyCallback,
        DiscussionEditCallback,
        DiscussionLikeCallback,
        DiscussionPermission,
        TextField,
        useDiscussionTileController,
        AppTokens;
import 'package:flutter/material.dart'
    show
        CrossAxisAlignment,
        Column,
        Widget,
        BuildContext,
        Text,
        CircularProgressIndicator,
        Icon,
        EdgeInsets,
        Expanded,
        MainAxisSize,
        Icons,
        Row,
        TextInputAction,
        MainAxisAlignment,
        Padding,
        Alignment,
        Align;
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget;
import 'package:theme_variants/theme_variants.dart' show ThemeVariantsContext;

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
    final discussionTileController = useDiscussionTileController(
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

    return Padding(
      padding: EdgeInsets.only(left: isNested ? tokens.spaceLayoutGapLg : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: tokens.spaceLayoutGapMd,
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
          if (discussionTileController.isEditing.value)
            Column(
              spacing: tokens.spaceLayoutGapMd,
              children: [
                if (discussionTileController.item.isReview)
                  TextField(
                    controller: discussionTileController.editTitleController,
                    maxLines: 1,
                    textInputAction: TextInputAction.next,
                    placeholder: 'Review title',
                  ),
                MarkdownText(
                  data: discussionTileController.editBody.value,
                  onChanged: (value) =>
                      discussionTileController.editBody.value = value,
                  mode: MarkdownTextMode.input,
                  placeholder: discussionTileController.item.isReview
                      ? 'Update review'
                      : 'Update comment',
                  maxLines: 8,
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: tokens.spaceLayoutGapMd,
              children: [
                if (item.isReview &&
                    !item.isDeleted &&
                    (item.title ?? '').isNotEmpty)
                  Text(item.title!),
                if (item.isDeleted)
                  Text(
                    'This ${item.isReview ? 'review' : 'comment'} was deleted.',
                  )
                else
                  MarkdownText(data: item.body),
              ],
            ),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: tokens.spaceLayoutGapSm,
            children: [
              if (discussionTileController.isEditing.value) ...[
                Button(
                  onPressed: isSubmitting
                      ? null
                      : discussionTileController.cancelEditing,
                  child: const Text('Cancel'),
                ),
                Button(
                  onPressed: isSubmitting
                      ? null
                      : discussionTileController.submitEdit,
                  leading: isSubmitting
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.check),
                  child: const Text('Save'),
                ),
              ] else ...[
                if (discussionTileController.canReply)
                  Button(
                    leading: const Icon(Icons.reply),
                    onPressed: isSubmitting
                        ? null
                        : discussionTileController.toggleReplying,
                  ),
                if (discussionTileController.canEditItem)
                  Button(
                    leading: const Icon(Icons.edit_outlined),
                    onPressed: isSubmitting
                        ? null
                        : discussionTileController.startEditing,
                  ),
                if (discussionTileController.item.isReview &&
                    discussionTileController.onLike != null)
                  Button(
                    leading: Icon(
                      discussionTileController.item.isLiked
                          ? Icons.thumb_down_alt_outlined
                          : Icons.thumb_up_alt_outlined,
                    ),
                    onPressed:
                        isSubmitting ||
                            discussionTileController.isLikeSubmitting.value
                        ? null
                        : discussionTileController.submitLike,
                  ),
              ],
            ],
          ),

          // Reply composer
          if (discussionTileController.isReplying.value)
            Column(
              spacing: tokens.spaceLayoutGapMd,
              children: [
                MarkdownText(
                  data: discussionTileController.replyBody.value,
                  onChanged: (value) =>
                      discussionTileController.replyBody.value = value,
                  mode: MarkdownTextMode.input,
                  placeholder: 'Write a reply',
                  maxLines: 6,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Button(
                    onPressed: isSubmitting
                        ? null
                        : discussionTileController.submitReply,
                    leading: isSubmitting
                        ? const CircularProgressIndicator()
                        : const Icon(Icons.send_outlined),
                    child: const Text('Post Reply'),
                  ),
                ),
              ],
            ),

          // Nested replies
          for (final reply in discussionTileController.replies)
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
