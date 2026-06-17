import 'package:boo_mondai/lib.barrel.dart'
    show
        SurfaceShape,
        surfaceStyle,
        AppTokens,
        SurfaceColor,
        textStyle,
        TextSize,
        TextWeight,
        TextColor;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

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
