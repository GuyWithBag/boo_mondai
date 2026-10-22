import 'package:boo_mondai/lib.barrel.dart'
    show
        SurfaceShape,
        surfaceStyle,
        AppTokens,
        SurfaceColor,
        textStyle,
        TextSize,
        TextWeight;
import 'package:flutter/material.dart'
    show StatelessWidget, Widget, BuildContext, Text, Expanded, Row;
import 'package:theme_variants/theme_variants.dart'
    show ThemeVariantsContext, Surface;

class PanelHeader extends StatelessWidget {
  const PanelHeader({required this.title, this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Surface(
      style: surfaceStyle.resolve(tokens, const [
        SurfaceColor.header,
        SurfaceShape.sharp,
      ]),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: textStyle.resolve(tokens, [
                TextSize.labelLarge,
                TextWeight.heavy,
              ]),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
