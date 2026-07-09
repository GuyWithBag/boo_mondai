import 'package:boo_mondai/lib.barrel.dart'
    show SnackbarTone, AppTokens, appSnackbarStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class Snackbar extends StatelessWidget {
  const Snackbar({
    super.key,
    required this.message,
    this.leading,
    this.tone = SnackbarTone.surface,
    this.minHeight = 60,
  });

  final String message;
  final Widget? leading;
  final SnackbarTone tone;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Padding(
      padding: EdgeInsets.all(tokens.spaceLayoutPaddingSm),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: minHeight,
          minWidth: double.infinity,
        ),
        child: Surface(
          style: appSnackbarStyle.resolve(tokens, [tone]),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[
                leading!,
                SizedBox(width: tokens.spaceLayoutGapSm),
              ],
              Flexible(child: SelectableText(message)),
            ],
          ),
        ),
      ),
    );
  }
}
