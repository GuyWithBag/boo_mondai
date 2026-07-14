import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonColor,
        ButtonPadding,
        ButtonVariant,
        buttonStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class FloatingActionButton extends StatelessWidget {
  const FloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    return Button(
      style: buttonStyle.resolve(tokens, const [
        ButtonColor.primary,
        ButtonVariant.elevated,
        ButtonPadding.none,
      ]),
      leading: Icon(icon),
      onPressed: onPressed,
    );
  }
}
