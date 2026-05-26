import 'package:boo_mondai/lib.barrel.dart'
    show
        TactileTone,
        AppModalTone,
        AppTokens,
        TactileButton,
        appTextStyle,
        TextSize,
        TextWeight,
        TextTone,
        AppModal;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class AppDialogAction<T> {
  const AppDialogAction({
    required this.value,
    required this.label,
    this.tone = TactileTone.ghost,
  });

  final T value;
  final String label;
  final TactileTone tone;
}

class AppChoiceDialog<T> extends StatelessWidget {
  const AppChoiceDialog({
    super.key,
    required this.title,
    required this.body,
    required this.actions,
    this.leading,
    this.tone = AppModalTone.surface,
  });

  final String title;
  final String body;
  final List<AppDialogAction<T>> actions;
  final Widget? leading;
  final AppModalTone tone;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(tokens.spacePanelGapLg),
      child: AppModal(
        tone: tone,
        leading: leading,
        actions: [
          for (final action in actions)
            TactileButton(
              tone: action.tone,
              onPressed: () => Navigator.pop(context, action.value),
              child: Text(action.label),
            ),
        ],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: appTextStyle.resolve(tokens, const [
                TextSize.header,
                TextWeight.heavy,
              ]),
            ),
            SizedBox(height: tokens.spacePanelGapSm),
            Text(
              body,
              textAlign: TextAlign.center,
              style: appTextStyle.resolve(tokens, const [
                TextSize.label,
                TextWeight.body,
                TextTone.secondary,
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

Future<T?> showAppChoiceDialog<T>({
  required BuildContext context,
  required String title,
  required String body,
  required List<AppDialogAction<T>> actions,
  Widget? leading,
  AppModalTone tone = AppModalTone.surface,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) => AppChoiceDialog<T>(
      title: title,
      body: body,
      actions: actions,
      leading: leading,
      tone: tone,
    ),
  );
}
