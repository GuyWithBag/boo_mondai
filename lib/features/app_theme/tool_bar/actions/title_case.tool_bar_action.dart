import 'package:flutter/material.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show TextHelper, ToolBarAction, ToolBarTextEditingControllerExtension;

final class TitleCaseToolBarAction extends ToolBarAction {
  const TitleCaseToolBarAction();

  @override
  IconData get icon => Icons.format_size;

  @override
  Future<void> perform(TextEditingController controller) async {
    controller.transformSelectedTextOrCurrentWord(TextHelper.toTitleCase);
  }
}
