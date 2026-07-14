import 'package:flutter/material.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        MarkdownFormatHelper,
        ToolBarAction,
        ToolBarTextEditingControllerExtension;

final class ItalicToolBarAction extends ToolBarAction {
  const ItalicToolBarAction();

  @override
  IconData get icon => Icons.format_italic;

  @override
  Future<void> perform(TextEditingController controller) async {
    controller.replaceSelection(
      MarkdownFormatHelper.toItalic(controller.selectedTextOr('italic text')),
    );
  }
}
