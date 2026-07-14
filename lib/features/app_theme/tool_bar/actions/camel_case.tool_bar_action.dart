import 'package:flutter/material.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show TextHelper, ToolBarAction, ToolBarTextEditingControllerExtension;

final class CamelCaseToolBarAction extends ToolBarAction {
  const CamelCaseToolBarAction();

  @override
  IconData get icon => Icons.text_fields;

  @override
  Future<void> perform(TextEditingController controller) async {
    controller.transformSelectedTextOrCurrentWord(TextHelper.toCamelCase);
  }
}
