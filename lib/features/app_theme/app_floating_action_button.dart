import 'package:boo_mondai/lib.barrel.dart' show TactileButton, TactileTone;
import 'package:flutter/material.dart';

class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({
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
    return TactileButton.icon(
      tone: TactileTone.mechanicalFilled,
      onPressed: onPressed,
      icon: icon,
    );
  }
}
