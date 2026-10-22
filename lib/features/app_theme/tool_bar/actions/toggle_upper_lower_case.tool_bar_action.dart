import 'package:flutter/material.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show ToolBarAction, ToolBarTextEditingControllerExtension;

final class ToggleUpperLowerCaseToolBarAction extends ToolBarAction {
  const ToggleUpperLowerCaseToolBarAction();

  @override
  IconData get icon => Icons.swap_vert;

  @override
  Future<void> perform(TextEditingController controller) async {
    controller.transformSelectedTextOrCurrentWord((text) {
      return text == text.toUpperCase()
          ? text.toLowerCase()
          : text.toUpperCase();
    });
  }
}
