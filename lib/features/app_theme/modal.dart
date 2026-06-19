import 'package:boo_mondai/lib.barrel.dart'
    show
        ModalTone,
        AppTokens,
        modalStyle,
        ModalAction,
        textStyle,
        TextSize,
        TextWeight,
        Button;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

Future<T?> showModal<T>({
  required BuildContext context,
  Icon? leading,
  String? title,
  String? subtitle,
  Widget? child,
  List<ModalAction<T>> actions = const [],
  List<Widget>? actionsCustom,
  ModalTone tone = ModalTone.surface,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) => Modal<T>(
      leading: leading,
      title: title,
      subtitle: subtitle,
      actions: actions,
      actionsCustom: actionsCustom,
      tone: tone,
      child: child,
    ),
  );
}

class Modal<T> extends StatelessWidget {
  const Modal({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.child,
    this.actions = const [],
    this.actionsCustom,
    this.tone = ModalTone.surface,
    this.maxWidth = 520,
  });

  final Icon? leading;
  final String? title;
  final String? subtitle;
  final Widget? child;
  final List<ModalAction<T>> actions;
  final List<Widget>? actionsCustom;
  final ModalTone tone;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    final hasActions =
        actions.isNotEmpty || (actionsCustom?.isNotEmpty ?? false);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Surface(
          style: modalStyle.resolve(tokens, [tone]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (leading != null) ...[
                IconTheme.merge(
                  data: IconThemeData(size: tokens.sizeIconLg),
                  child: leading!,
                ),
                SizedBox(height: tokens.spaceLayoutGapLg),
              ],
              if (title != null)
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: textStyle.resolve(tokens, const [
                    TextSize.header,
                    TextWeight.heavy,
                  ]),
                ),
              if (subtitle != null) ...[
                SizedBox(height: tokens.spaceLayoutGapSm),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: textStyle.resolve(tokens, const [
                    TextSize.label,
                    TextWeight.body,
                  ]),
                ),
              ],
              if (child != null) ...[
                SizedBox(height: tokens.spaceLayoutGapSm),
                child!,
              ],
              if (hasActions) ...[
                SizedBox(height: tokens.spaceLayoutGapLg),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: tokens.spaceLayoutGapSm,
                  runSpacing: tokens.spaceLayoutGapSm,
                  children: [
                    ...actions.map(
                      (action) => Button(
                        variants: [action.color],
                        onPressed: () {
                          action.onPressed?.call();
                          Navigator.pop(context, action.value);
                        },
                        child: Text(action.label),
                      ),
                    ),
                    ...?actionsCustom,
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
