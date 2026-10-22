import 'package:flutter/material.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        MarkdownFormatHelper,
        ToolBarAction,
        ToolBarTextEditingControllerExtension;

final class Heading1ToolBarAction extends ToolBarAction {
  const Heading1ToolBarAction();

  @override
  IconData get icon => Icons.title;

  @override
  Future<void> perform(TextEditingController controller) async {
    controller.replaceSelection(
      MarkdownFormatHelper.toHeading(controller.selectedTextOr('Heading'), 1),
    );
  }
}
