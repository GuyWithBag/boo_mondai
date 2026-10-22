import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, SnackbarColor, SnackbarVariant, snackbarStyle;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class Snackbar extends StatelessWidget {
  const Snackbar({
    super.key,
    required this.message,
    this.leading,
    this.content,
    this.child,
    this.color = SnackbarColor.surface,
    this.variant = SnackbarVariant.elevated,
    this.variants = const [],
    this.minHeight = 60,
  });

  final String message;
  final Widget? leading;
  final Widget? content;
  final Widget? child;
  final SnackbarColor color;
  final SnackbarVariant variant;
  final List<Object> variants;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final resolvedStyle = snackbarStyle.resolve(tokens, [
      color,
      variant,
      ...variants,
    ]);

    final snackbar = Padding(
      padding: EdgeInsets.all(tokens.spaceLayoutPaddingSm),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: minHeight,
          minWidth: double.infinity,
        ),
        child: Surface(
          style: resolvedStyle,
          child:
              content ??
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
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

    return Padding(
      padding: resolvedStyle.transform != null
          ? EdgeInsets.only(top: tokens.modalShadowOffset.h)
          : EdgeInsets.zero,
      child: snackbar,
    );
  }
}
