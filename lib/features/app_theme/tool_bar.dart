import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, SurfaceBorder, SurfacePadding, SurfaceShape, surfaceStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class ToolBar extends StatelessWidget implements PreferredSizeWidget {
  const ToolBar({
    super.key,
    this.actions = const [],
    this.preferredHeight = ToolBar.preferredHeightDefault,
  });

  final List<Widget> actions;
  final double preferredHeight;

  static const double preferredHeightDefault = 72;

  @override
  Size get preferredSize => Size(0, preferredHeight);

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Surface(
      style: surfaceStyle.resolve(tokens, [
        SurfaceBorder.top,
        // SurfaceShape.topRounded,
        SurfacePadding.sm,
        SurfaceShape.roundedXsm,
      ]),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(spacing: tokens.spaceLayoutGapSm, children: actions),
        ),
      ),
    );
  }
}
