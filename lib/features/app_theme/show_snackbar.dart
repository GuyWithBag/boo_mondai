import 'package:boo_mondai/lib.barrel.dart' show SnackbarTone, Snackbar;
import 'package:flutter/material.dart';

void showSnackbar(
  BuildContext context, {
  required String message,
  Widget? leading,
  SnackbarTone tone = SnackbarTone.surface,
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
