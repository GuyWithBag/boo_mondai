import 'package:flutter/material.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        MarkdownFormatHelper,
        ToolBarAction,
        ToolBarTextEditingControllerExtension;

final class ImageToolBarAction extends ToolBarAction {
  const ImageToolBarAction();

  @override
  IconData get icon => Icons.add_photo_alternate_outlined;

  @override
  Future<void> perform(TextEditingController controller) async {
    controller.replaceSelection(
      MarkdownFormatHelper.toImage(controller.selectedTextOr('image alt')),
    );
  }
}
