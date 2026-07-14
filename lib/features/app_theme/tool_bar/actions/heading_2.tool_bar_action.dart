import 'package:flutter/material.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        MarkdownFormatHelper,
        ToolBarAction,
        ToolBarTextEditingControllerExtension;

final class Heading2ToolBarAction extends ToolBarAction {
  const Heading2ToolBarAction();

  @override
  IconData get icon => Icons.format_size;

  @override
  Future<void> perform(TextEditingController controller) async {
    controller.replaceSelection(
      MarkdownFormatHelper.toHeading(controller.selectedTextOr('Heading'), 2),
    );
  }
}
