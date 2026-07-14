import 'package:flutter/material.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        MarkdownFormatHelper,
        ToolBarAction,
        ToolBarTextEditingControllerExtension;

final class BoldToolBarAction extends ToolBarAction {
  const BoldToolBarAction();

  @override
  IconData get icon => Icons.format_bold;

  @override
  Future<void> perform(TextEditingController controller) async {
    controller.replaceSelection(
      MarkdownFormatHelper.toBold(controller.selectedTextOr('bold text')),
    );
  }
}
