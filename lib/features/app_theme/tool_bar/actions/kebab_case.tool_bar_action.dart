import 'package:flutter/material.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show StringHelper, ToolBarAction, ToolBarTextEditingControllerExtension;

final class KebabCaseToolBarAction extends ToolBarAction {
  const KebabCaseToolBarAction();

  @override
  IconData get icon => Icons.horizontal_rule;

  @override
  Future<void> perform(TextEditingController controller) async {
    controller.transformSelectedTextOrCurrentWord(StringHelper.toKebabCase);
  }
}
