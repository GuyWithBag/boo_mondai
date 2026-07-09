import 'package:boo_mondai/features/app_theme/text_field.variant.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        DiscussionFormValidator,
        DiscussionType,
        FormField,
        TextField,
        ToggleButton,
        surfaceStyle,
        SurfaceBorder,
        SurfaceShape,
        SurfacePadding,
        ButtonVariant;
import 'package:flutter/material.dart'
    show
        Text,
        CircularProgressIndicator,
        Widget,
        BuildContext,
        SizedBox,
        TextInputAction,
        Form,
        FormState,
        GlobalKey,
        Expanded,
        Row,
        Column;
import 'package:flutter_hooks/flutter_hooks.dart'
    show HookWidget, useMemoized, useTextEditingController, useState;
import 'package:theme_variants/theme_variants.dart';

class DiscussionComposerTile extends HookWidget {
  const DiscussionComposerTile({
    super.key,
    required this.type,
    required this.isSubmitting,
    this.onReviewSubmitted,
    this.onCommentSubmitted,
  }) : assert(
         type == DiscussionType.review
             ? onReviewSubmitted != null
             : onCommentSubmitted != null,
         'Provide onReviewSubmitted for review, onCommentSubmitted for comment.',
       );

  final DiscussionType type;
  final bool isSubmitting;
  final Future<bool> Function({
    required int voteValue,
    required String title,
    required String body,
  })?
  onReviewSubmitted;
  final Future<bool> Function(String body, {String? parentCommentId})?
  onCommentSubmitted;

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController();
    final bodyController = useTextEditingController();
    final voteValue = useState(1);
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final tokens = context.themeTokens<AppTokens>();
    final isReview = type == DiscussionType.review;
    final isPositiveVote = voteValue.value > 0;
    final shouldDisplayReviewFields = isReview;
    final shouldEnableVoteToggle = !isSubmitting;
    final shouldEnableSubmitAction = !isSubmitting;
    final shouldDisplaySubmitProgress = isSubmitting;
    final bodyPlaceholder = isReview ? 'Write a review' : 'Write a comment';
    final submitButtonLabel = isReview ? 'Post Review' : 'Post Comment';

    Future<bool> submit() {
      if (isReview) {
        return onReviewSubmitted!(
          voteValue: voteValue.value,
          title: titleController.text,
          body: bodyController.text,
        );
      } else {
        return onCommentSubmitted!(bodyController.text);
      }
    }

    void clearFields() {
      titleController.clear();
      bodyController.clear();
    }

    return Form(
      key: formKey,
      child: Surface(
        style: surfaceStyle.resolve(tokens, const [
          SurfaceBorder.none,
          SurfaceShape.roundedSm,
          SurfacePadding.sm,
        ]),
        child: Column(
          spacing: tokens.spaceLayoutGapMd,
          children: [
            if (shouldDisplayReviewFields) ...[
              Row(
                spacing: tokens.spaceLayoutGapSm,
                children: [
                  Expanded(
                    child: FormField<String>(
                      value: titleController.text,
                      listenable: titleController,
                      valueReader: () => titleController.text,
                      validator: DiscussionFormValidator.title,
                      builder: (_, field) => TextField(
                        controller: titleController,
                        minLines: 1,
                        maxLines: 1,
                        textInputAction: TextInputAction.next,
                        placeholder: 'Review title',
                        onChanged: field.didChange,
                        variants: const [
                          TextFieldFrame.underline,
                          TextFieldColor.transparentBg,
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: FormField<int>(
                      value: voteValue.value,
                      listenable: voteValue,
                      valueReader: () => voteValue.value,
                      validator: DiscussionFormValidator.vote,
                      builder: (_, field) => ToggleButton(
                        variant: ButtonVariant.flat,
                        value: isPositiveVote,
                        onChanged: shouldEnableVoteToggle
                            ? (value) {
                                final vote = value ? 1 : -1;
                                voteValue.value = vote;
                                field.didChange(vote);
                              }
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            Column(
              spacing: tokens.spaceLayoutGapSm,
              children: [
                FormField<String>(
                  value: bodyController.text,
                  listenable: bodyController,
                  valueReader: () => bodyController.text,
                  validator: DiscussionFormValidator.body,
                  builder: (_, field) => TextField(
                    controller: bodyController,
                    minLines: 4,
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                    placeholder: bodyPlaceholder,
                    onChanged: field.didChange,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Button(
                    onPressed: shouldEnableSubmitAction
                        ? () async {
                            if (!formKey.currentState!.validate()) return;
                            final posted = await submit();
                            if (posted) {
                              clearFields();
                              formKey.currentState?.reset();
                            }
                          }
                        : null,
                    child: shouldDisplaySubmitProgress
                        ? const SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(submitButtonLabel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
