import 'package:boo_mondai/lib.barrel.dart'
    show
        ButtonTone,
        AppModalTone,
        AppTokens,
        Button,
        textStyle,
        TextSize,
        TextWeight,
        TextTone,
        Modal;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class ModalAction<T> {
  const ModalAction({
    required this.value,
    required this.label,
    this.tone = ButtonTone.ghost,
  });

  final T value;
  final String label;
  final ButtonTone tone;
}

class ChoiceModal<T> extends StatelessWidget {
  const ChoiceModal({
    super.key,
    required this.title,
    required this.body,
    required this.actions,
    this.leading,
    this.tone = AppModalTone.surface,
  });

  final String title;
  final String body;
  final List<ModalAction<T>> actions;
  final Widget? leading;
  final AppModalTone tone;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(tokens.spaceLayoutGapLg),
      child: Modal(
        tone: tone,
        leading: leading,
        actions: [
          for (final action in actions)
            Button(
              variants: [action.tone],
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
              style: textStyle.resolve(tokens, const [
                TextSize.header,
                TextWeight.heavy,
              ]),
            ),
            SizedBox(height: tokens.spaceLayoutGapSm),
            Text(
              body,
              textAlign: TextAlign.center,
              style: textStyle.resolve(tokens, const [
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

Future<T?> showChoiceModal<T>({
  required BuildContext context,
  required String title,
  required String body,
  required List<ModalAction<T>> actions,
  Widget? leading,
  AppModalTone tone = AppModalTone.surface,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) => ChoiceModal<T>(
      title: title,
      body: body,
      actions: actions,
      leading: leading,
      tone: tone,
    ),
  );
}
