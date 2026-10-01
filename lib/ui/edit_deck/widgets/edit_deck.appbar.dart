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
        BottomNavBar,
        EditDeckController,
        AppTokens;
import 'package:flutter/material.dart' hide AppBar;
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class EditDeckAppBar extends SignalHookWidget implements PreferredSizeWidget {
  const EditDeckAppBar({super.key, required this.controller});

  final EditDeckController controller;

  @override
  Size get preferredSize => Size(0, BottomNavBar.preferredHeightDefault);

  @override
  Widget build(BuildContext context) {
    final selectedTemplate = controller.selectedTemplate.value;
    final tokens = context.themeTokens<AppTokens>();

    return AppBar(
      onPop: () => controller.onPop(context),
      actions: [
        Button.icon(
          tokens: tokens,
          icon: Icons.delete_outline,
          color: ButtonColor.error,
          onPressed: controller.isLoading.value || selectedTemplate == null
              ? null
              : () => controller.deleteSelectedCard(context),
        ),
        Button.icon(
          tokens: tokens,
          icon: Icons.visibility_outlined,
          onPressed: selectedTemplate == null
              ? null
              : () => context.push(
                  '/cards/${selectedTemplate.id}/preview',
                  extra: selectedTemplate,
                ),
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
}
