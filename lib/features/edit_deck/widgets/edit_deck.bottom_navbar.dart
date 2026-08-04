import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        BottomNavBar,
        Button,
        EditDeckController,
        EditDeckQuestionTypeHelper,
        useSelectionController;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class EditDeckBottomNavBar extends HookWidget implements PreferredSizeWidget {
  const EditDeckBottomNavBar({required this.editor, super.key});

  final EditDeckController editor;

  @override
  Size get preferredSize => Size(0, BottomNavBar.preferredHeightDefault);

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final formats = EditDeckQuestionTypeHelper.visibleQuestionTypes;
    final selection = useSelectionController<int>(
      selectedValues: [editor.selectedFormatIndex],
      onSelectionChanged: (selected) {
        if (selected.isEmpty) return;
        editor.setFormatIndex(selected.first);
      },
    );

    return BottomNavBar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: tokens.spaceLayoutGapSm,
          children: [
            for (var index = 0; index < formats.length; index++) ...[
              Button(
                leading: Icon(
                  EditDeckQuestionTypeHelper.iconFor(formats[index]),
                ),
                selected: selection.isSelected(index),
                onPressed: () => selection.select(index),
                child: Text(
                  EditDeckQuestionTypeHelper.labelFor(formats[index]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
