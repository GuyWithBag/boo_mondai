import 'package:flutter/material.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        MarkdownFormatHelper,
        ToolBarAction,
        ToolBarTextEditingControllerExtension;

final class CodeBlockToolBarAction extends ToolBarAction {
  const CodeBlockToolBarAction();

  @override
  IconData get icon => Icons.data_object;

  @override
  Future<void> perform(TextEditingController controller) async {
    controller.replaceSelection(
      MarkdownFormatHelper.toCodeBlock(controller.selectedTextOr('code')),
    );
  }
}
