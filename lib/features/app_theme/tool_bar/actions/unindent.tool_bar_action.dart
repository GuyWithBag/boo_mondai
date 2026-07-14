import 'package:flutter/material.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show ToolBarAction, ToolBarTextEditingControllerExtension;

final class UnindentToolBarAction extends ToolBarAction {
  const UnindentToolBarAction();

  @override
  IconData get icon => Icons.format_indent_decrease;

  @override
  Future<void> perform(TextEditingController controller) async {
    controller.replaceSelectedWholeLines(
      fallback: '',
      transform: (text) {
        return text
            .split('\n')
            .map((line) {
              if (line.startsWith('  ')) return line.substring(2);
              if (line.startsWith('\t')) return line.substring(1);
              if (line.startsWith(' ')) return line.substring(1);
              return line;
            })
            .join('\n');
      },
    );
  }
}
