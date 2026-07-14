import 'package:flutter/material.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        MarkdownFormatHelper,
        ToolBarAction,
        ToolBarTextEditingControllerExtension;

final class InlineCodeToolBarAction extends ToolBarAction {
  const InlineCodeToolBarAction();

  @override
  IconData get icon => Icons.code;

  @override
  Future<void> perform(TextEditingController controller) async {
    controller.replaceSelection(
      MarkdownFormatHelper.toInlineCode(controller.selectedTextOr('code')),
    );
  }
}
