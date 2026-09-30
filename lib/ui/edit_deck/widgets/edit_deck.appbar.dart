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
        EditDeckController;
import 'package:flutter/material.dart' hide AppBar;
import 'package:signals_hooks/signals_hooks.dart';

class EditDeckAppBar extends SignalHookWidget implements PreferredSizeWidget {
  const EditDeckAppBar({super.key, required this.controller});

  final EditDeckController controller;

  @override
  Size get preferredSize => Size(0, BottomNavBar.preferredHeightDefault);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      onPop: () => controller.onPop(context),
      actions: [
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
        variants: const [TextFieldSize.bodyLarge, TextFieldFrame.none],
      ),
    );
  }
}
