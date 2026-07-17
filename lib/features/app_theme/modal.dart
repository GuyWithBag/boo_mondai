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
  bool showCancelButton = false,
  MainAxisAlignment actionsMainAxisAlignment = MainAxisAlignment.end,
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
      showCancelButton: showCancelButton,
      actionsMainAxisAlignment: actionsMainAxisAlignment,
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
    this.showCancelButton = false,
    this.actionsMainAxisAlignment = MainAxisAlignment.end,
  });

  final Icon? leading;
  final String? title;
  final String? subtitle;
  final Widget? child;
  final List<ModalAction<T>> actions;
  final List<Widget>? actionsCustom;
  final ModalTone tone;
  final double maxWidth;
  final bool showCancelButton;
  final MainAxisAlignment actionsMainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    final hasActions =
        actions.isNotEmpty || (actionsCustom?.isNotEmpty ?? false);

    return Padding(
      padding: EdgeInsets.all(tokens.spaceScaffoldPadding),
      child: Center(
        child: Material(
          type: MaterialType.transparency,
          child: Surface(
            style: modalStyle.resolve(tokens, [tone]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (showCancelButton) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Button.icon(
                        tokens: tokens,
                        icon: Icons.close,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: tokens.spaceLayoutGapXsm),
                ],
                if (leading != null) ...[
                  IconTheme.merge(
                    data: IconThemeData(size: tokens.sizeModalIcon),
                    child: leading!,
                  ),
                  SizedBox(height: tokens.spaceLayoutGapSm),
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
                  Row(
                    spacing: tokens.spaceLayoutGapSm,
                    mainAxisAlignment: actionsMainAxisAlignment,
                    children: [
                      ...actions.map(
                        (action) => Button(
                          variants: [action.color],
                          onPressed: () {
                            action.onPressed?.call();
                            if (!action.dismissesModal) return;

                            final valueBuilder = action.valueBuilder;
                            final value = valueBuilder == null
                                ? action.value
                                : valueBuilder();
                            Navigator.pop(context, value);
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
      ),
    );
  }
}
