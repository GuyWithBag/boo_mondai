import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, SurfaceBorder, surfaceStyle, ThemeController;
import 'package:flutter/material.dart';
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class BottomNavBar extends SignalHookWidget implements PreferredSizeWidget {
  const BottomNavBar({
    super.key,
    required this.child,
    this.variants = const [],
    this.preferredHeight = BottomNavBar.preferredHeightDefault,
    this.padding,
  });

  final Widget child;
  final List<Object> variants;
  final double preferredHeight;
  final EdgeInsets? padding;

  static const double preferredHeightDefault = 90;

  @override
  Size get preferredSize => Size(0, preferredHeight);

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeController.tokens;
    return Surface(
      style: surfaceStyle
          .resolve(tokens, [...variants, SurfaceBorder.top])
          .copyWith(padding: padding),
      child: SafeArea(top: false, child: child),
    );
  }
}
