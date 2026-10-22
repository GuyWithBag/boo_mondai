import 'package:flutter/material.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        MarkdownFormatHelper,
        ToolBarAction,
        ToolBarTextEditingControllerExtension;

final class TaskListToolBarAction extends ToolBarAction {
  const TaskListToolBarAction();

  @override
  IconData get icon => Icons.check_box_outlined;

  @override
  Future<void> perform(TextEditingController controller) async {
    final selected = controller.selectedText;
    final replacement = selected.isEmpty
        ? MarkdownFormatHelper.toTaskListItem('Task')
        : selected
              .split('\n')
              .map(MarkdownFormatHelper.toTaskListItem)
              .join('\n');
    controller.replaceSelection(replacement);
  }
}
