import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        BottomNavBar,
        Button,
        EditDeckController,
        EditDeckQuestionTypeHelper;
import 'package:flutter/material.dart';
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

    return BottomNavBar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          spacing: tokens.spaceLayoutGapSm,
          children: [
            for (final format in formats) ...[
              Button(
                leading: Icon(EditDeckQuestionTypeHelper.iconFor(format)),
                selected: format == selectedType,
                onPressed: () => editor.changeSelectedTemplateType(format),
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
