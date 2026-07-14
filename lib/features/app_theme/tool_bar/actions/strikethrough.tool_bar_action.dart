import 'package:flutter/material.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        MarkdownFormatHelper,
        ToolBarAction,
        ToolBarTextEditingControllerExtension;

final class StrikethroughToolBarAction extends ToolBarAction {
  const StrikethroughToolBarAction();

  @override
  IconData get icon => Icons.format_strikethrough;

  @override
  Future<void> perform(TextEditingController controller) async {
    controller.replaceSelection(
      MarkdownFormatHelper.toStrikethrough(
        controller.selectedTextOr('strikethrough text'),
      ),
    );
  }
}
