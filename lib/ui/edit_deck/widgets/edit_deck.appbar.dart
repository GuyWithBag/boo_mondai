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
        BottomNavBar;
import 'package:flutter/material.dart' hide AppBar;

class EditDeckAppBar extends StatelessWidget implements PreferredSizeWidget {
  const EditDeckAppBar({
    required this.titleController,
    required this.onSave,
    this.isSaving = false,
    super.key,
  });

  final TextEditingController titleController;
  final Future<void> Function() onSave;
  final bool isSaving;

  @override
  Size get preferredSize => Size(0, BottomNavBar.preferredHeightDefault);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        Button(
          variants: const [
            ButtonColor.primary,
            ButtonSize.icon,
            ButtonPadding.none,
          ],
          onPressed: isSaving ? null : onSave,
          leading: isSaving
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save),
        ),
      ],
      child: MarkdownText(
        allowAttachments: true,
        data: titleController.text,
        controller: titleController,
        placeholder: 'Deck Title...',
        mode: MarkdownTextMode.input,
        variants: const [TextFieldSize.bodyLarge, TextFieldFrame.none],
      ),
    );
  }
}
