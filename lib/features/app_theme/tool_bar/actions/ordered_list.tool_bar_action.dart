import 'package:flutter/material.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        MarkdownFormatHelper,
        ToolBarAction,
        ToolBarTextEditingControllerExtension;

final class OrderedListToolBarAction extends ToolBarAction {
  const OrderedListToolBarAction();

  @override
  IconData get icon => Icons.format_list_numbered;

  @override
  Future<void> perform(TextEditingController controller) async {
    final selected = controller.selectedText;
    if (selected.isEmpty) {
      controller.replaceSelection(
        MarkdownFormatHelper.toOrderedListItem('List item', 1),
      );
      return;
    }

    final lines = selected.split('\n');
    controller.replaceSelection(
      [
        for (var index = 0; index < lines.length; index++)
          MarkdownFormatHelper.toOrderedListItem(lines[index], index + 1),
      ].join('\n'),
    );
  }
}
