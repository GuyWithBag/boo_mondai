import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        SegmentOption,
        SegmentedControl,
        SurfaceColor,
        TextColor,
        TextSize,
        TextWeight,
        surfaceStyle,
        textStyle;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class CardVerticalAlignmentControl extends StatelessWidget {
  const CardVerticalAlignmentControl({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Surface(
      style: surfaceStyle.resolve(tokens, const [SurfaceColor.baseline]),
      child: Column(
        spacing: tokens.spaceLayoutGapMd,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            spacing: tokens.spaceLayoutGapMd,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Vertical Alignment',
                style: textStyle.resolve(tokens, [
                  TextSize.labelLarge,
                  TextWeight.heavy,
                ]),
              ),
              Text(
                'Choose how short card content sits inside the study card. '
                'Long content still scrolls.',
                style: textStyle.resolve(tokens, [
                  TextSize.label,
                  TextWeight.body,
                  TextColor.muted,
                ]),
              ),
            ],
          ),
          SegmentedControl<bool>(
            options: const [
              SegmentOption(value: false, label: 'Top'),
              SegmentOption(value: true, label: 'Center'),
            ],
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
