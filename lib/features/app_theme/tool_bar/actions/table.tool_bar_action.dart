import 'package:flutter/material.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        MarkdownFormatHelper,
        ToolBarAction,
        ToolBarTextEditingControllerExtension;

final class TableToolBarAction extends ToolBarAction {
  const TableToolBarAction();

  @override
  IconData get icon => Icons.table_chart_outlined;

  @override
  Future<void> perform(TextEditingController controller) async {
    controller.replaceSelection(MarkdownFormatHelper.toTable());
  }
}
