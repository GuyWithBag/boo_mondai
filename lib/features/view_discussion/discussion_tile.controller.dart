import 'package:boo_mondai/lib.barrel.dart' show DiscussionItem;
import 'package:flutter/material.dart'
    show ValueNotifier, TextEditingController;
import 'package:flutter_hooks/flutter_hooks.dart'
    show useTextEditingController, useState, useEffect;

typedef DiscussionRepliesFor = List<DiscussionItem> Function(String itemId);
typedef DiscussionReplyCallback =
    Future<bool> Function(String body, {String? parentCommentId});
typedef DiscussionEditCallback =
    Future<bool> Function(DiscussionItem item, String body, {String? title});
typedef DiscussionPermission = bool Function(DiscussionItem item);
typedef DiscussionLikeCallback = Future<bool> Function(DiscussionItem item);

class DiscussionTileController {
  DiscussionTileController({
    required this.item,
    required this.replies,
    required this.replyBody,
    required this.editBody,
    required this.editTitleController,
    required this.isReplying,
    required this.isEditing,
    required this.isLikeSubmitting,
    required this.canReply,
    required this.canEditItem,
    required this.onReply,
    required this.onEdit,
    required this.onLike,
  });

  final DiscussionItem item;
  final List<DiscussionItem> replies;
  final ValueNotifier<String> replyBody;
  final ValueNotifier<String> editBody;
  final TextEditingController editTitleController;
  final ValueNotifier<bool> isReplying;
  final ValueNotifier<bool> isEditing;
  final ValueNotifier<bool> isLikeSubmitting;
  final bool canReply;
  final bool canEditItem;
  final DiscussionReplyCallback? onReply;
  final DiscussionEditCallback? onEdit;
  final DiscussionLikeCallback? onLike;

  void startEditing() {
    editTitleController.text = item.title ?? '';
    editBody.value = item.body;
    isEditing.value = true;
  }

  void cancelEditing() {
    editTitleController.text = item.title ?? '';
    editBody.value = item.body;
    isEditing.value = false;
  }

  void toggleReplying() => isReplying.value = !isReplying.value;

  Future<void> submitEdit() async {
    final saved = await onEdit!(
      item,
      editBody.value,
      title: item.isReview ? editTitleController.text : null,
    );
    if (saved) isEditing.value = false;
  }

  Future<void> submitReply() async {
    final posted = await onReply!(replyBody.value, parentCommentId: item.id);
    if (posted) {
      replyBody.value = '';
      isReplying.value = false;
    }
  }

  Future<void> submitLike() async {
    isLikeSubmitting.value = true;
    await onLike!(item);
    isLikeSubmitting.value = false;
  }
}

DiscussionTileController useDiscussionTileController({
  required DiscussionItem item,
  required DiscussionRepliesFor repliesFor,
  required DiscussionReplyCallback? onReply,
  required DiscussionEditCallback? onEdit,
  required DiscussionLikeCallback? onLike,
  required DiscussionPermission? canEdit,
}) {
  final replyBody = useState('');
  final editBody = useState(item.body);
  final editTitleController = useTextEditingController(text: item.title ?? '');
  final isReplying = useState(false);
  final isEditing = useState(false);
  final isLikeSubmitting = useState(false);

  useEffect(() {
    if (!isEditing.value) {
      editTitleController.text = item.title ?? '';
      editBody.value = item.body;
    }
    return null;
  }, [item.title, item.body, isEditing.value]);

  return DiscussionTileController(
    item: item,
    replies: repliesFor(item.id),
    replyBody: replyBody,
    editBody: editBody,
    editTitleController: editTitleController,
    isReplying: isReplying,
    isEditing: isEditing,
    isLikeSubmitting: isLikeSubmitting,
    canReply: onReply != null && !item.isDeleted,
    canEditItem: onEdit != null && (canEdit?.call(item) ?? false),
    onReply: onReply,
    onEdit: onEdit,
    onLike: onLike,
  );
}
