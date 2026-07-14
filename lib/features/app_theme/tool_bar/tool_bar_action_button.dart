import 'package:boo_mondai/lib.barrel.dart'
    show ToolBarController, ToolBarAction, AppTokens, Button;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class ToolBarActionButton extends StatelessWidget {
  const ToolBarActionButton({
    required this.action,
    required this.controller,
    super.key,
  });

  final ToolBarAction action;
  final ToolBarController controller;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final onPressed = controller.canPerform(action)
            ? () => controller.perform(action)
            : null;

        return Button.icon(
          icon: action.icon,
          onPressed: onPressed,
          tokens: tokens,
        );
      },
    );
  }
}
