import 'package:flutter/material.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        MarkdownFormatHelper,
        ToolBarAction,
        ToolBarTextEditingControllerExtension;

final class BlockQuoteToolBarAction extends ToolBarAction {
  const BlockQuoteToolBarAction();

  @override
  IconData get icon => Icons.format_quote;

  @override
  Future<void> perform(TextEditingController controller) async {
    controller.replaceSelectedWholeLines(
      fallback: MarkdownFormatHelper.toBlockQuote('Quote'),
      transform: (text) {
        if (text.isEmpty) return MarkdownFormatHelper.toBlockQuote('Quote');
        return text
            .split('\n')
            .map(MarkdownFormatHelper.toBlockQuote)
            .join('\n');
      },
    );
  }
}
