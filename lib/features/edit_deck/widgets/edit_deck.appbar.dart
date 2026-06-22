import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        Button,
        ButtonColor,
        HeaderBadge,
        MarkdownText,
        MarkdownTextMode,
        MetaLabel,
        TextFieldFrame,
        TextFieldSize,
        TextFieldColor;
import 'package:flutter/material.dart'
    show
        TextEditingController,
        StatelessWidget,
        PreferredSizeWidget,
        Size,
        Widget,
        BuildContext,
        CrossAxisAlignment,
        MainAxisAlignment,
        Icons,
        Column,
        Row;
import 'package:theme_variants/theme_variants.dart';

class EditDeckAppbar extends StatelessWidget implements PreferredSizeWidget {
  const EditDeckAppbar({
    required this.titleController,
    required this.onSave,
    this.isSaving = false,
    super.key,
  });

  final TextEditingController titleController;
  final Future<void> Function() onSave;
  final bool isSaving;

  static const _toolbarHeight = 88.0;

  @override
  Size get preferredSize => const Size.fromHeight(_toolbarHeight);

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return AppBar(
      // subSection: Row(
      //   mainAxisAlignment: MainAxisAlignment.end,
      //   children: [
      //     Button(
      //       variants: const [ButtonColor.primary],
      //       onPressed: isSaving ? null : onSave,
      //       child: isSaving
      //           ? const SizedBox.square(
      //               dimension: 18,
      //               child: CircularProgressIndicator(strokeWidth: 2),
      //             )
      //           : const Text('Save'),
      //     ),
      //   ],
      // ),
      actions: [
        Button.icon(
          color: ButtonColor.primary,
          onPressed: isSaving ? null : onSave,
          icon: Icons.save,
        ),
      ],
      child: Column(
        // spacing: tokens.spaceLayoutGapSm,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            spacing: tokens.spaceLayoutGapSm,
            children: [
              const HeaderBadge(label: 'Draft Deck'),
              const MetaLabel(icon: Icons.lock, label: 'Private'),
            ],
          ),
          MarkdownText(
            data: titleController.text,
            controller: titleController,
            placeholder: 'Deck Title...',
            mode: MarkdownTextMode.input,
            variants: const [TextFieldSize.labelLarge, TextFieldFrame.none],
          ),
        ],
      ),
    );
  }
}
