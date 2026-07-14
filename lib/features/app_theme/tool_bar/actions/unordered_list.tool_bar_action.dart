import 'package:flutter/material.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        MarkdownFormatHelper,
        ToolBarAction,
        ToolBarTextEditingControllerExtension;

final class UnorderedListToolBarAction extends ToolBarAction {
  const UnorderedListToolBarAction();

  @override
  IconData get icon => Icons.format_list_bulleted;

  @override
  Future<void> perform(TextEditingController controller) async {
    final selected = controller.selectedText;
    final replacement = selected.isEmpty
        ? MarkdownFormatHelper.toUnorderedListItem('List item')
        : selected
              .split('\n')
              .map(MarkdownFormatHelper.toUnorderedListItem)
              .join('\n');
    controller.replaceSelection(replacement);
  }
}
