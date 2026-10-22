import 'package:boo_mondai/lib.barrel.dart' show Comment, Review;
import 'package:flutter/material.dart';
import 'package:signals/signals_core.dart';

class DiscussionComposerController<T extends Comment> {
  DiscussionComposerController({required T initComment}) {
    comment.value = initComment;
  }

  late final Signal<T> comment;

  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  final isReviewPositive = signal<bool?>(false);

  final formKey = GlobalKey<FormState>();

  late final isReview = computed(() => comment is Review);

  final isSubmitting = signal(false);

  late final shouldDisplayReviewFields = computed(() => isReview.value);

  late final shouldEnableVoteToggle = computed(() => !isSubmitting.value);
  late final shouldEnableSubmitAction = computed(() => !isSubmitting.value);
  late final shouldDisplaySubmitProgress = computed(() => isSubmitting.value);

  late final bodyPlaceholder = computed(
    () => isReview.value ? 'Write a review' : 'Write a comment',
  );
  late final submitButtonLabel = computed(
    () => isReview.value ? 'Post Review' : 'Post Comment',
  );

  void clear() {
    titleController.clear();
    bodyController.clear();
  }

  void onSubmitPressed() {}
}
