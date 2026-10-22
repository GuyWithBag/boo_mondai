// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/widgets/error_text.dart
// PURPOSE: Selectable error message widget with theme error color
// PROVIDERS: none
// HOOKS: none
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, TextColor, textStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class ErrorText extends StatelessWidget {
  const ErrorText(this.message, {super.key});

  factory ErrorText.exception(Exception? exception, {Key? key}) {
    return ErrorText(exception?.toString(), key: key);
  }

  final String? message;

  @override
  Widget build(BuildContext context) {
    final message = this.message;
    if (message == null) {
      return SizedBox.shrink();
    }
    final tokens = context.themeTokens<AppTokens>();

    return SelectableText(
      message,
      style: textStyle.resolve(tokens, const [TextColor.error]),
    );
  }
}
