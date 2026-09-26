// ignore_for_file: dead_code

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonVariant,
        DiscussionFormValidator,
        DiscussionTileController,
        FormField,
        MarkdownText,
        MarkdownTextMode,
        MetaLabel,
        ProfileLabel,
        Review,
        SurfaceBorder,
        SurfacePadding,
        SurfaceShape,
        surfaceStyle,
        DateHelper;
import 'package:flutter/material.dart' hide FormField;
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget;
import 'package:theme_variants/theme_variants.dart'
    show ThemeVariantsContext, Surface;

class DiscussionTile extends HookWidget {
  const DiscussionTile({super.key, required this.controller});

  final DiscussionTileController controller;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final item = controller.item;
    final content = item.content;

    return Padding(
      padding: EdgeInsets.only(
        left: tokens.spaceLayoutGapLg * controller.depth,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: tokens.spaceLayoutGapSm,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: tokens.spaceLayoutGapSm,
            children: [
              ProfileLabel(
                label: 'By',
                displayName: item.profile.username,
                avatar: item.profile.avatarUrl == null
                    ? NetworkImage(item.profile.avatarUrl!)
                    : null,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: tokens.spaceLayoutGapSm,
                children: [
                  MetaLabel(
                    label: DateHelper.formatDateDdMmYy(content.createdAt),
                    icon: Icons.calendar_today_outlined,
                  ),
                  MetaLabel(
                    label: DateHelper.formatDateDdMmYy(content.updatedAt),
                    icon: controller.hasEditLogs
                        ? Icons.edit_calendar_outlined
                        : Icons.update,
                  ),
                ],
              ),
            ],
          ),

          // Body: editable or display
          if (controller.isEditing.value)
            Form(
              key: controller.editFormKey,
              child: Column(
                spacing: tokens.spaceLayoutGapSm,
                children: [
                  if (controller.shouldDisplayEditTitleField.value)
                    FormField<String>(
                      value: controller.editTitleController.text,
                      validator: DiscussionFormValidator.title,
                      builder: (_, field) => MarkdownText(
                        data: controller.editTitleController.text,
                        controller: controller.editTitleController,
                        maxLines: 1,
                        textInputAction: TextInputAction.next,
                        placeholder: 'Review title',
                        onChanged: field.didChange,
                        mode: MarkdownTextMode.input,
                      ),
                    ),
                  FormField<String>(
                    value: controller.editBodyText.value,
                    validator: DiscussionFormValidator.body,
                    builder: (_, field) => MarkdownText(
                      data: controller.editBodyText.value,
                      allowAttachments: true,
                      onChanged: (value) {
                        controller.editBodyText.value = value;
                        field.didChange(value);
                      },
                      mode: MarkdownTextMode.input,
                      placeholder: 'Write here.',
                      maxLines: null,
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: tokens.spaceLayoutGapSm,
              children: [
                if (controller.shouldDisplayReviewTitle.value)
                  Surface(
                    style: surfaceStyle.resolve(tokens, const [
                      SurfaceBorder.none,
                      SurfaceShape.roundedXsm,
                      SurfacePadding.sm,
                    ]),
                    child: MarkdownText(
                      data: (item.content as Review).title,
                      mode: MarkdownTextMode.previewSelectable,
                    ),
                  ),
                Surface(
                  style: surfaceStyle.resolve(tokens, const [
                    SurfaceBorder.none,
                    SurfaceShape.roundedXsm,
                    SurfacePadding.sm,
                  ]),
                  child: controller.shouldDisplayIsDeleted
                      ? SelectableText('This comment was deleted.')
                      : ConstrainedBox(
                          constraints: BoxConstraints(minHeight: 100),
                          child: MarkdownText(
                            data: item.owner.body,
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
              if (controller.isEditing.value) ...[
                Button(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : controller.onCancelEditPressed,
                  child: const Text('Cancel'),
                ),
                Button(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : controller.onSubmitEdit,
                  leading: controller.isSubmitting.value
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.check),
                  child: const Text('Submit'),
                ),
              ] else ...[
                Button.icon(
                  icon: Icons.reply,
                  tokens: tokens,
                  onPressed: controller.isSubmitting.value
                      ? null
                      : controller.onReplyPressed,
                ),
                if (controller.shouldDisplayEditAction.value)
                  Button.icon(
                    icon: Icons.edit_outlined,
                    tokens: tokens,
                    onPressed: controller.isSubmitting.value
                        ? null
                        : controller.onEditPressed,
                  ),
                Button.icon(
                  tokens: tokens,
                  icon: controller.isLiked
                      ? Icons.thumb_down_alt_outlined
                      : Icons.thumb_up_alt_outlined,
                  variant: ButtonVariant.flat,
                  onPressed: controller.onLikePressed,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
