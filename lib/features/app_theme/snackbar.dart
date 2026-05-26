import 'package:boo_mondai/lib.barrel.dart'
    show AppSnackbarTone, AppTokens, appSnackbarStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class Snackbar extends StatelessWidget {
  const Snackbar({
    super.key,
    required this.message,
    this.leading,
    this.tone = AppSnackbarTone.surface,
    this.maxWidth = 520,
  });

  final String message;
  final Widget? leading;
  final AppSnackbarTone tone;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Surface(
          style: appSnackbarStyle.resolve(tokens, [tone]),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[
                leading!,
                SizedBox(width: tokens.spacePanelGapSm),
              ],
              Flexible(child: SelectableText(message)),
            ],
          ),
        ),
      ),
    );
  }
}

void showAppSnackbar({
  required BuildContext context,
  required String message,
  Widget? leading,
  AppSnackbarTone tone = AppSnackbarTone.surface,
  Duration duration = const Duration(seconds: 2),
  bool clearCurrent = true,
}) {
  final messenger = ScaffoldMessenger.of(context);

  if (clearCurrent) {
    messenger.clearSnackBars();
  }

  messenger.showSnackBar(
    SnackBar(
      content: Snackbar(message: message, leading: leading, tone: tone),
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      dismissDirection: DismissDirection.horizontal,
    ),
  );
}
