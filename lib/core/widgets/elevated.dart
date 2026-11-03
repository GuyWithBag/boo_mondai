import 'package:boo_mondai/lib.barrel.dart' show AppTokens, ThemeController;
import 'package:flutter/material.dart';

class Elevated extends StatelessWidget {
  const Elevated({
    super.key,
    required this.child,
    this.enabled = true,
    this.contentScale = 1,
  });

  final Widget child;
  final bool enabled;
  final double contentScale;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeController.tokens;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          if (enabled)
            BoxShadow(
              blurRadius: 10 * contentScale,
              offset: Offset(0, 1 * contentScale),
              color: tokens.colorLayoutShadow,
            ),
        ],
      ),
      child: child,
    );
  }
}
