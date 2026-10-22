import 'package:flutter/material.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show StringHelper, ToolBarAction, ToolBarTextEditingControllerExtension;

final class SnakeCaseToolBarAction extends ToolBarAction {
  const SnakeCaseToolBarAction();

  @override
  IconData get icon => Icons.keyboard_double_arrow_down;

  @override
  Future<void> perform(TextEditingController controller) async {
    controller.transformSelectedTextOrCurrentWord(StringHelper.toSnakeCase);
  }
}
