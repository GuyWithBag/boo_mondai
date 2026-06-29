import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        BottomNavBar,
        Button,
        EditDeckController,
        useSelectionController;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class EditDeckBottomNavBar extends HookWidget implements PreferredSizeWidget {
  const EditDeckBottomNavBar({required this.editor, super.key});

  final EditDeckController editor;

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(0, BottomNavBar.preferredHeightDefault);

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final formats = [
      (Icons.slideshow_outlined, 'Flashcard'),
      (Icons.list, 'Multiple Choice'),
      (Icons.draw, 'Fill in Blanks'),
      (Icons.shuffle, 'Match Madness'),
    ];
    final selection = useSelectionController<int>(
      selectedValues: [editor.selectedFormatIndex],
      onSelectionChanged: (selected) {
        if (selected.isEmpty) return;
        editor.setFormatIndex(selected.first);
      },
    );

    return BottomNavBar(
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                spacing: tokens.spaceLayoutGapSm,
                children: [
                  for (var index = 0; index < formats.length; index++) ...[
                    Button(
                      leading: Icon(formats[index].$1),
                      selected: selection.isSelected(index),
                      onPressed: () => selection.select(index),
                      child: Text(
                        formats[index].$2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SizedBox(width: tokens.spaceLayoutGapMd),
        ],
      ),
    );
  }
}
