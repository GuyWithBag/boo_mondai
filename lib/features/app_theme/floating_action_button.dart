import 'package:boo_mondai/lib.barrel.dart'
    show Button, ButtonColor, ButtonVariant;
import 'package:flutter/material.dart';

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
    return Button.icon(
      color: ButtonColor.primary,
      variant: ButtonVariant.elevated,
      onPressed: onPressed,
      icon: icon,
    );
  }
}
