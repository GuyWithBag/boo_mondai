import 'package:flutter/material.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show ToolBarAction, ToolBarTextEditingControllerExtension;

final class IndentToolBarAction extends ToolBarAction {
  const IndentToolBarAction();

  @override
  IconData get icon => Icons.format_indent_increase;

  @override
  Future<void> perform(TextEditingController controller) async {
    controller.replaceSelectedWholeLines(
      fallback: '',
      transform: (text) => text.split('\n').map((line) => '  $line').join('\n'),
    );
  }
}
