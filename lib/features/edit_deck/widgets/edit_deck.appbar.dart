import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        Button,
        ButtonColor,
        ButtonPadding,
        buttonStyle,
        HeaderBadge,
        MarkdownText,
        MarkdownTextMode,
        MetaLabel,
        TextFieldFrame,
        TextFieldSize,
        ButtonSize,
        BottomNavBar;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show
        TextEditingController,
        StatelessWidget,
        Widget,
        BuildContext,
        CrossAxisAlignment,
        MainAxisAlignment,
        Icons,
        SizedBox,
        CircularProgressIndicator,
        Icon,
        Column,
        Row;
import 'package:theme_variants/theme_variants.dart';

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
    final tokens = context.themeTokens<AppTokens>();

    return AppBar(
      actions: [
        Button(
          style: buttonStyle.resolve(tokens, const [
            ButtonColor.primary,
            ButtonSize.icon,
            ButtonPadding.none,
          ]),
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
