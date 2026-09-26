import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        Comment,
        DiscussionFormValidator,
        FormField,
        MarkdownText,
        MarkdownTextMode,
        SurfaceBorder,
        SurfacePadding,
        SurfaceShape,
        TextField,
        surfaceStyle,
        TextFieldFrame,
        TextFieldColor,
        DiscussionComposerController;
import 'package:flutter/material.dart' hide FormField, TextField;
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class DiscussionComposerTile<T extends Comment> extends SignalHookWidget {
  const DiscussionComposerTile({super.key, required this.controller});

  final DiscussionComposerController controller;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Form(
      key: controller.formKey,
      child: Surface(
        style: surfaceStyle.resolve(tokens, const [
          SurfaceBorder.none,
          SurfaceShape.roundedSm,
          SurfacePadding.sm,
        ]),
        child: Column(
          spacing: tokens.spaceLayoutGapMd,
          children: [
            if (controller.shouldDisplayReviewFields.value) ...[
              Row(
                spacing: tokens.spaceLayoutGapSm,
                children: [
                  Expanded(
                    child: FormField<String>(
                      value: controller.titleController.text,
                      validator: DiscussionFormValidator.title,
                      builder: (_, field) => TextField(
                        controller: controller.titleController,
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
                  // SizedBox(
                  //   width: 140,
                  //   child: FormField<bool?>(
                  //     value: isReviewPositive.value,
                  //     validator: DiscussionFormValidator.vote,
                  //     builder: (_, field) => ToggleButton(
                  //       variant: ButtonVariant.flat,
                  //       value: isReviewPositive.value,
                  //       onChanged: shouldEnableVoteToggle
                  //           ? (value) {
                  //               final vote = value ? 1 : -1;
                  //               voteValue.value = vote;
                  //               field.didChange(vote);
                  //             }
                  //           : null,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
            Column(
              spacing: tokens.spaceLayoutGapSm,
              children: [
                FormField<String>(
                  value: controller.bodyController.text,
                  validator: DiscussionFormValidator.body,
                  builder: (_, field) => MarkdownText(
                    data: controller.bodyController.text,
                    controller: controller.bodyController,
                    allowAttachments: true,
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                    placeholder: controller.bodyPlaceholder.value,
                    onChanged: field.didChange,
                    mode: MarkdownTextMode.input,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Button(
                    onPressed: controller.onSubmitPressed,
                    child: controller.shouldDisplaySubmitProgress.value
                        ? const SizedBox.square(
                            dimension: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(controller.submitButtonLabel.value),
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
