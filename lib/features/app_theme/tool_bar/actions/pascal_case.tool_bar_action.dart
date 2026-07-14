import 'package:flutter/material.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show TextHelper, ToolBarAction, ToolBarTextEditingControllerExtension;

final class PascalCaseToolBarAction extends ToolBarAction {
  const PascalCaseToolBarAction();

  @override
  IconData get icon => Icons.title;

  @override
  Future<void> perform(TextEditingController controller) async {
    controller.transformSelectedTextOrCurrentWord(TextHelper.toPascalCase);
  }
}
