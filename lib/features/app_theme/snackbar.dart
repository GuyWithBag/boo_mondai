import 'package:boo_mondai/lib.barrel.dart'
    show SnackbarTone, AppTokens, appSnackbarStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class Snackbar extends StatelessWidget {
  const Snackbar({
    super.key,
    required this.message,
    this.leading,
    this.content,
    this.child,
    this.tone = SnackbarTone.surface,
    this.minHeight = 60,
  });

  final String message;
  final Widget? leading;
  final Widget? content;
  final Widget? child;
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
          child:
              content ??
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (leading != null) ...[
                        leading!,
                        SizedBox(width: tokens.spaceLayoutGapSm),
                      ],
                      Flexible(child: SelectableText(message)),
                    ],
                  ),
                  if (child != null) ...[
                    SizedBox(height: tokens.spaceLayoutGapSm),
                    child!,
                  ],
                ],
              ),
        ),
      ),
    );
  }
}
