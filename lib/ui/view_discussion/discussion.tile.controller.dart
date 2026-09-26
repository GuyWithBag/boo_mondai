import 'package:boo_mondai/lib.barrel.dart'
    show CommentWithDepth, Profile, ProfileService, Review;
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class DiscussionTileController {
  DiscussionTileController({
    required this.item,
    this.onReplyPressed,
    this.onEditPressed,
    this.onLikePressed,
    required this.depth,
    this.onCancelEditPressed,
    this.onSubmitEdit,
  });

  final TextEditingController editTitleController = TextEditingController();
  late final editTitleText = linkedSignal(() => editTitleController.text);

  final TextEditingController editBodyController = TextEditingController();
  late final editBodyText = linkedSignal(() => editBodyController.text);

  final CommentWithDepth item;
  final VoidCallback? onReplyPressed;
  final VoidCallback? onLikePressed;
  final VoidCallback? onEditPressed;
  final VoidCallback? onCancelEditPressed;
  final VoidCallback? onSubmitEdit;

  final int depth;

  final editFormKey = GlobalKey<FormState>(
    debugLabel: 'Discussion Edit Form key ',
  );

  Profile get currentProfile => ProfileService.currentProfile.value;

  final isEditing = signal(false);
  final isSubmitting = signal(false);

  late final isEditable = Computed(
    () => currentProfile.id == item.content.profileId,
  );

  late final shouldDisplayEditTitleField = Computed(
    () => item.owner is Review && isEditing.value,
  );
  late final shouldDisplayReviewTitle = Computed(() => item.owner is Review);

  late final shouldDisplayEditAction = Computed(
    () => isEditable.value && currentProfile.id == item.content.profileId,
  );

  // ToDo: These
  final isLiked = false;
  final shouldDisplayIsDeleted = false;
  final hasEditLogs = false;
}
