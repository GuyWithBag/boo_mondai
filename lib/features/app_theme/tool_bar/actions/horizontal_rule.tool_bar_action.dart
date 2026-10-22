import 'package:flutter/material.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        MarkdownFormatHelper,
        ToolBarAction,
        ToolBarTextEditingControllerExtension;

final class HorizontalRuleToolBarAction extends ToolBarAction {
  const HorizontalRuleToolBarAction();

  @override
  IconData get icon => Icons.horizontal_rule;

  @override
  Future<void> perform(TextEditingController controller) async {
    controller.replaceSelection(MarkdownFormatHelper.toHorizontalRule());
  }
}
