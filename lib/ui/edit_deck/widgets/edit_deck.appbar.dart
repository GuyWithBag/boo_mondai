import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        Button,
        ButtonColor,
        ButtonPadding,
        MarkdownText,
        MarkdownTextMode,
        TextFieldFrame,
        TextFieldSize,
        ButtonSize,
        EditDeckController,
        AppTokens;
import 'package:flutter/material.dart' hide AppBar;
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:theme_variants/theme_variants.dart';

AppBar buildEditDeckAppBar({
  required BuildContext context,
  required EditDeckController controller,
}) {
  final selectedTemplate = controller.selectedTemplate.value;
  final tokens = context.themeTokens<AppTokens>();

  return AppBar(
    onPop: () => controller.onPop(context),
    actions: [Button.iconOnly(icon: Icons.more_vert)],
    preferredHeaderHeight: 58,
    header: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: tokens.spaceLayoutGapSm,
      children: [
        Button.icon(
          tokens: tokens,
          icon: Icons.visibility_outlined,
          onPressed: selectedTemplate == null
              ? null
              : () => context.push(
                  '/view-cards/${selectedTemplate.id}',
                  extra: selectedTemplate,
                ),
        ),
        Button.icon(
          tokens: tokens,
          icon: Icons.delete_outline,
          color: ButtonColor.error,
          onPressed: controller.isLoading.value || selectedTemplate == null
              ? null
              : () => controller.deleteSelectedCard(context),
        ),
        Button(
          variants: const [
            ButtonColor.primary,
            ButtonSize.icon,
            ButtonPadding.none,
          ],
          onPressed:
              controller.isLoading.value || controller.isDirty.value == false
              ? null
              : () async {
                  await controller.save(context);
                },
          leading: controller.isLoading.value
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save),
        ),
      ],
    ),
    child: MarkdownText(
      allowAttachments: true,
      data: controller.titleController.text,
      controller: controller.titleController,
      placeholder: 'Deck Title...',
      mode: MarkdownTextMode.input,
      variants: const [TextFieldSize.header, TextFieldFrame.none],
    ),
  );
}
