import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, SurfaceBorder, surfaceStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class BottomNavBar extends StatelessWidget implements PreferredSizeWidget {
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
  // TODO: implement preferredSize
  Size get preferredSize => Size(0, preferredHeight);

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    return Surface(
      style: surfaceStyle
          .resolve(tokens, [...variants, SurfaceBorder.top])
          .copyWith(padding: padding),
      child: SafeArea(top: false, child: child),
    );
  }
}
