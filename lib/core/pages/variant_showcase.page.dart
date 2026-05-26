import 'package:boo_mondai/features/app_theme/tactile_button.variant.dart'
    show
        TactileTone,
        tactileButtonStyle,
        TactileSize,
        TactileState,
        TactileDepth;
import 'package:boo_mondai/lib.barrel.dart' show AppTokens, AppSpacing;
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
            style: tactileButtonStyle,
            previewText: 'Action',
            axes: const [
              VariantShowcaseAxis(
                label: 'Tone',
                variants: [
                  TactileTone.filled,
                  TactileTone.ghost,
                  TactileTone.success,
                  TactileTone.error,
                  TactileTone.streak,
                  TactileTone.dashed,
                  TactileTone.text,
                  TactileTone.again,
                  TactileTone.hard,
                  TactileTone.good,
                  TactileTone.easy,
                  TactileTone.mechanicalFilled,
                  TactileTone.mechanicalGhost,
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          VariantShowcaseGrid<AppTokens>(
            title: const Text('Button sizes'),
            style: tactileButtonStyle,
            previewText: 'Action',
            axes: const [
              VariantShowcaseAxis(
                label: 'Size',
                variants: [
                  TactileSize.sm,
                  TactileSize.md,
                  TactileSize.lg,
                  TactileSize.icon,
                  TactileSize.fab,
                  TactileSize.extendedFab,
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          VariantShowcaseGrid<AppTokens>(
            title: const Text('Button states'),
            style: tactileButtonStyle,
            previewText: 'Action',
            axes: const [
              VariantShowcaseAxis(
                label: 'State',
                variants: [
                  TactileState.idle,
                  TactileState.hovered,
                  TactileState.selected,
                  TactileState.disabled,
                  TactileState.pressed,
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          VariantShowcaseGrid<AppTokens>(
            title: const Text('Mechanical FAB variants'),
            style: tactileButtonStyle,
            previewText: 'Action',
            axes: const [
              VariantShowcaseAxis(
                label: 'Tone',
                variants: [
                  TactileTone.mechanicalFilled,
                  TactileTone.mechanicalGhost,
                ],
              ),
              VariantShowcaseAxis(
                label: 'Size',
                variants: [TactileSize.fab, TactileSize.extendedFab],
              ),
              VariantShowcaseAxis(
                label: 'Depth',
                variants: [TactileDepth.mechanical],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
