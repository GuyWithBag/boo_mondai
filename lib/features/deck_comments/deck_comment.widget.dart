import 'package:boo_mondai/lib.barrel.dart'
    show
        AppSpacing,
        CachedProfile,
        DeckComment,
        DeckVoteReview,
        DeckVoteReviewComment,
        MarkdownText,
        MarkdownTextMode,
        ProfileLabel;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum DeckCommentKind { comment, review }

typedef DeckCommentRepliesFor = List<DeckCommentItem> Function(String itemId);
typedef DeckCommentReplyCallback =
    Future<bool> Function(String body, {String? parentCommentId});
typedef DeckCommentEditCallback =
    Future<bool> Function(DeckCommentItem item, String body, {String? title});
typedef DeckCommentPermission = bool Function(DeckCommentItem item);
typedef DeckCommentLikeCallback = Future<bool> Function(DeckCommentItem item);

class DeckCommentItem {
  const DeckCommentItem({
    required this.id,
    required this.userId,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    this.parentCommentId,
    this.title,
    this.isDeleted = false,
    this.userProfile,
    this.kind = DeckCommentKind.comment,
    this.isLiked = false,
  });

  factory DeckCommentItem.fromDeckComment(DeckComment comment) {
    return DeckCommentItem(
      id: comment.id,
      userId: comment.userId,
      parentCommentId: comment.parentCommentId,
      body: comment.body,
      isDeleted: comment.isDeleted,
      createdAt: comment.createdAt,
      updatedAt: comment.updatedAt,
      userProfile: comment.userProfile,
    );
  }

  factory DeckCommentItem.fromReview(
    DeckVoteReview review, {
    bool isLiked = false,
  }) {
    return DeckCommentItem(
      id: review.id,
      userId: review.userId,
      title: review.title,
      body: review.body,
      isDeleted: review.isDeleted,
      createdAt: review.createdAt,
      updatedAt: review.updatedAt,
      userProfile: review.userProfile,
      kind: DeckCommentKind.review,
      isLiked: isLiked,
    );
  }

  factory DeckCommentItem.fromReviewComment(DeckVoteReviewComment comment) {
    return DeckCommentItem(
      id: comment.id,
      userId: comment.userId,
      parentCommentId: comment.parentCommentId,
      body: comment.body,
      isDeleted: comment.isDeleted,
      createdAt: comment.createdAt,
      updatedAt: comment.updatedAt,
      userProfile: comment.userProfile,
    );
  }

  final String id;
  final String userId;
  final String? parentCommentId;
  final String? title;
  final String body;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CachedProfile? userProfile;
  final DeckCommentKind kind;
  final bool isLiked;

  bool get isReview => kind == DeckCommentKind.review;
}

class DeckCommentWidget extends HookWidget {
  const DeckCommentWidget({
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

  final DeckCommentItem item;
  final DeckCommentRepliesFor repliesFor;
  final DeckCommentReplyCallback? onReply;
  final DeckCommentEditCallback? onEdit;
  final DeckCommentLikeCallback? onLike;
  final DeckCommentPermission? canEdit;
  final bool isSubmitting;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final replies = repliesFor(item.id);
    final replyBody = useState('');
    final editBody = useState(item.body);
    final editTitleController = useTextEditingController(
      text: item.title ?? '',
    );
    final isReplying = useState(false);
    final isEditing = useState(false);
    final isLikeSubmitting = useState(false);
    final canReply = onReply != null && !item.isDeleted;
    final canEditItem = onEdit != null && (canEdit?.call(item) ?? false);
    final isNested = depth > 0;

    useEffect(() {
      if (!isEditing.value) {
        editTitleController.text = item.title ?? '';
        editBody.value = item.body;
      }
      return null;
    }, [item.title, item.body, isEditing.value]);

    return Padding(
      padding: EdgeInsets.only(left: isNested ? AppSpacing.lg : 0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: isNested
              ? Border(
                  left: BorderSide(color: scheme.outlineVariant, width: 1.5),
                )
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: isNested ? AppSpacing.md : 0,
            top: AppSpacing.sm,
            bottom: AppSpacing.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CommentHeader(item: item),
              const SizedBox(height: AppSpacing.sm),
              if (isEditing.value)
                _EditableBody(
                  item: item,
                  titleController: editTitleController,
                  body: editBody.value,
                  onBodyChanged: (value) {
                    editBody.value = value;
                  },
                )
              else
                _CommentBody(item: item),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isEditing.value) ...[
                    TextButton(
                      onPressed: isSubmitting
                          ? null
                          : () {
                              editTitleController.text = item.title ?? '';
                              editBody.value = item.body;
                              isEditing.value = false;
                            },
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    FilledButton.icon(
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              final saved = await onEdit!(
                                item,
                                editBody.value,
                                title: item.isReview
                                    ? editTitleController.text
                                    : null,
                              );
                              if (saved) isEditing.value = false;
                            },
                      icon: isSubmitting
                          ? const SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check),
                      label: const Text('Save'),
                    ),
                  ] else ...[
                    if (canReply)
                      IconButton(
                        tooltip: 'Reply',
                        onPressed: isSubmitting
                            ? null
                            : () {
                                isReplying.value = !isReplying.value;
                              },
                        icon: const Icon(Icons.reply),
                      ),
                    if (canEditItem)
                      IconButton(
                        tooltip: 'Edit',
                        onPressed: isSubmitting
                            ? null
                            : () {
                                editTitleController.text = item.title ?? '';
                                editBody.value = item.body;
                                isEditing.value = true;
                              },
                        icon: const Icon(Icons.edit_outlined),
                      ),
                    if (item.isReview && onLike != null)
                      IconButton(
                        tooltip: item.isLiked ? 'Remove like' : 'Like review',
                        onPressed: isSubmitting || isLikeSubmitting.value
                            ? null
                            : () async {
                                isLikeSubmitting.value = true;
                                await onLike!(item);
                                isLikeSubmitting.value = false;
                              },
                        icon: Icon(
                          item.isLiked
                              ? Icons.thumb_down_alt_outlined
                              : Icons.thumb_up_alt_outlined,
                        ),
                      ),
                  ],
                ],
              ),
              if (isReplying.value) ...[
                const SizedBox(height: AppSpacing.sm),
                _CommentInput(
                  value: replyBody.value,
                  onChanged: (value) {
                    replyBody.value = value;
                  },
                  hintText: 'Write a reply',
                  maxLines: 6,
                ),
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: isSubmitting
                        ? null
                        : () async {
                            final posted = await onReply!(
                              replyBody.value,
                              parentCommentId: item.id,
                            );
                            if (posted) {
                              replyBody.value = '';
                              isReplying.value = false;
                            }
                          },
                    icon: isSubmitting
                        ? const SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send_outlined),
                    label: const Text('Post Reply'),
                  ),
                ),
              ],
              if (replies.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                for (final reply in replies)
                  DeckCommentWidget(
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
            ],
          ),
        ),
      ),
    );
  }
}

class _CommentHeader extends StatelessWidget {
  const _CommentHeader({required this.item});

  final DeckCommentItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ProfileLabel(
            label: 'By',
            displayName: item.userProfile?.username ?? 'Unknown author',
            avatarUrl: item.userProfile?.avatarUrl,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        _CommentDates(item: item),
      ],
    );
  }
}

class _CommentBody extends StatelessWidget {
  const _CommentBody({required this.item});

  final DeckCommentItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textColor = item.isDeleted
        ? scheme.onSurfaceVariant
        : scheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (item.isReview && !item.isDeleted && (item.title ?? '').isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Text(
              item.title!,
              style: theme.textTheme.titleMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        if (item.isDeleted)
          Text(
            'This ${item.isReview ? 'review' : 'comment'} was deleted.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontStyle: FontStyle.italic,
            ),
          )
        else
          DefaultTextStyle.merge(
            style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
            child: MarkdownText(data: item.body),
          ),
      ],
    );
  }
}

class _EditableBody extends StatelessWidget {
  const _EditableBody({
    required this.item,
    required this.titleController,
    required this.body,
    required this.onBodyChanged,
  });

  final DeckCommentItem item;
  final TextEditingController titleController;
  final String body;
  final ValueChanged<String> onBodyChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (item.isReview) ...[
          TextField(
            controller: titleController,
            maxLines: 1,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'Review title',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        _CommentInput(
          value: body,
          onChanged: onBodyChanged,
          hintText: item.isReview ? 'Update review' : 'Update comment',
          maxLines: 8,
        ),
      ],
    );
  }
}

class _CommentDates extends StatelessWidget {
  const _CommentDates({required this.item});

  final DeckCommentItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final wasEdited =
        item.updatedAt.difference(item.createdAt).abs() >
        const Duration(seconds: 1);

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.xs,
      alignment: WrapAlignment.end,
      children: [
        _DateChip(
          icon: Icons.calendar_today_outlined,
          label: _formatDate(item.createdAt),
          style: style,
        ),
        _DateChip(
          icon: wasEdited ? Icons.edit_calendar_outlined : Icons.update,
          label: _formatDate(item.updatedAt),
          style: style,
        ),
      ],
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.icon,
    required this.label,
    required this.style,
  });

  final IconData icon;
  final String label;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: style),
      ],
    );
  }
}

class _CommentInput extends StatelessWidget {
  const _CommentInput({
    required this.value,
    required this.onChanged,
    required this.hintText,
    this.maxLines = 6,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String hintText;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return MarkdownText(
      data: value,
      onChanged: onChanged,
      mode: MarkdownTextMode.input,
      placeholder: hintText,
      maxLines: maxLines,
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
