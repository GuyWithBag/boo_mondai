import 'package:flutter/material.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        MarkdownFormatHelper,
        ToolBarAction,
        ToolBarTextEditingControllerExtension;

final class LinkToolBarAction extends ToolBarAction {
  const LinkToolBarAction();

  @override
  IconData get icon => Icons.link;

  @override
  Future<void> perform(TextEditingController controller) async {
    controller.replaceSelection(
      MarkdownFormatHelper.toLink(controller.selectedTextOr('link')),
    );
  }
}
