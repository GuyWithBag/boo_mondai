import 'package:boo_mondai/lib.barrel.dart'
    show
        SurfaceShape,
        surfaceStyle,
        AppTokens,
        SurfaceTone,
        appTextStyle,
        TextSize,
        TextWeight,
        TextTone;
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
        SurfaceTone.header,
        SurfaceShape.sharp,
      ]),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: appTextStyle.resolve(tokens, [
                TextSize.labelLarge,
                TextWeight.heavy,
                TextTone.primary,
              ]),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
