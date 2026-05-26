import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        AppSpacing,
        ButtonTone,
        buttonStyle,
        ButtonSize,
        ButtonState,
        ButtonDepth;
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class VariantShowcasePage extends StatelessWidget {
  const VariantShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Variant Showcase')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          VariantShowcaseGrid<AppTokens>(
            title: const Text('Button tones'),
            style: buttonStyle,
            previewText: 'Action',
            axes: const [
              VariantShowcaseAxis(
                label: 'Tone',
                variants: [
                  ButtonTone.filled,
                  ButtonTone.ghost,
                  ButtonTone.success,
                  ButtonTone.error,
                  ButtonTone.streak,
                  ButtonTone.dashed,
                  ButtonTone.text,
                  ButtonTone.again,
                  ButtonTone.hard,
                  ButtonTone.good,
                  ButtonTone.easy,
                  ButtonTone.mechanicalFilled,
                  ButtonTone.mechanicalGhost,
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          VariantShowcaseGrid<AppTokens>(
            title: const Text('Button sizes'),
            style: buttonStyle,
            previewText: 'Action',
            axes: const [
              VariantShowcaseAxis(
                label: 'Size',
                variants: [
                  ButtonSize.sm,
                  ButtonSize.md,
                  ButtonSize.lg,
                  ButtonSize.icon,
                  ButtonSize.fab,
                  ButtonSize.extendedFab,
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          VariantShowcaseGrid<AppTokens>(
            title: const Text('Button states'),
            style: buttonStyle,
            previewText: 'Action',
            axes: const [
              VariantShowcaseAxis(
                label: 'State',
                variants: [
                  ButtonState.idle,
                  ButtonState.hovered,
                  ButtonState.selected,
                  ButtonState.disabled,
                  ButtonState.pressed,
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          VariantShowcaseGrid<AppTokens>(
            title: const Text('Mechanical FAB variants'),
            style: buttonStyle,
            previewText: 'Action',
            axes: const [
              VariantShowcaseAxis(
                label: 'Tone',
                variants: [
                  ButtonTone.mechanicalFilled,
                  ButtonTone.mechanicalGhost,
                ],
              ),
              VariantShowcaseAxis(
                label: 'Size',
                variants: [ButtonSize.fab, ButtonSize.extendedFab],
              ),
              VariantShowcaseAxis(
                label: 'Depth',
                variants: [ButtonDepth.mechanical],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
