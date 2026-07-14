import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        CardTemplateFormState,
        SegmentOption,
        SegmentedControl,
        SurfaceColor,
        TextColor,
        TextSize,
        TextWeight,
        surfaceStyle,
        textStyle;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class CardVerticalAlignmentControl extends HookWidget {
  const CardVerticalAlignmentControl({required this.formState, super.key});

  final CardTemplateFormState formState;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final verticallyCentered = useValueListenable(formState.verticallyCentered);

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
            value: verticallyCentered,
            onChanged: (value) => formState.verticallyCentered.value = value,
          ),
        ],
      ),
    );
  }
}
