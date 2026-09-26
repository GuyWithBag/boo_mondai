import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        BottomNavBar,
        Button,
        CardTemplateType,
        EditDeckController,
        EditDeckQuestionTypeHelper,
        useSelectionController,
        SelectionController;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class EditDeckBottomNavBar extends SignalHookWidget
    implements PreferredSizeWidget {
  const EditDeckBottomNavBar({required this.editor, super.key});

  final EditDeckController editor;

  @override
  Size get preferredSize => Size(0, BottomNavBar.preferredHeightDefault);

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final formats = EditDeckQuestionTypeHelper.visibleQuestionTypes;
    final selectedType = editor.selectedCardTemplateType.value;
    final selection = useMemoized(
      () => SelectionController<CardTemplateType>(
        selectedValues: {selectedType},
        onSelectionChanged: (selected) {
          if (selected.isEmpty) return;
          editor.onCardTemplateTypeSelected(selected.first);
        },
      ),
    );

    return BottomNavBar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: tokens.spaceLayoutGapSm,
          children: [
            for (final format in formats) ...[
              Button(
                leading: Icon(EditDeckQuestionTypeHelper.iconFor(format)),
                selected: selection.isSelected(format),
                onPressed: () => selection.select(format),
                child: Text(
                  EditDeckQuestionTypeHelper.labelFor(format),
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
