import 'package:boo_mondai/lib.barrel.dart'
    show AppBar, AppTokens, Button, ButtonColor, HeaderBadge, MetaLabel;
import 'package:flutter/material.dart'
    show
        TextEditingController,
        StatelessWidget,
        PreferredSizeWidget,
        Size,
        Widget,
        BuildContext,
        InputDecoration,
        SizedBox,
        Text,
        CrossAxisAlignment,
        MainAxisAlignment,
        Icons,
        FontWeight,
        TextField,
        TextStyle,
        Column,
        CircularProgressIndicator,
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
          TextField(
            controller: titleController,
            decoration: const InputDecoration.collapsed(
              hintText: 'Deck Title...',
            ),
          ),
        ],
      ),
    );
  }
}
