import 'package:boo_mondai/lib.barrel.dart'
    show
        SurfaceShape,
        SurfaceShadow,
        CasingType,
        AppTokens,
        surfaceStyle,
        SurfaceColor,
        SurfaceBorder,
        SurfacePadding,
        textStyle,
        TextSize,
        TextWeight,
        TextColor,
        MarkdownTextMode,
        TextFieldSize,
        TextFieldFrame,
        MarkdownText,
        Button,
        SegmentOption,
        SegmentedControl;
import 'package:flutter/material.dart';
import 'package:signals/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart';

class AnswerKeyTile extends SignalHookWidget {
  const AnswerKeyTile({
    super.key,
    required this.index,
    required this.value,
    required this.casingType,
    required this.canMoveUp,
    required this.canMoveDown,
    required this.canRemove,
    required this.onCasingTypeChanged,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onRemove,
    this.onAnswerChanged,
    this.valueChild,
  });

  final int index;
  final String value;
  final CasingType casingType;
  final bool canMoveUp;
  final bool canMoveDown;
  final bool canRemove;
  final ValueChanged<String>? onAnswerChanged;
  final ValueChanged<CasingType> onCasingTypeChanged;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onRemove;
  final Widget? valueChild;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Surface(
      style: surfaceStyle
          .resolve(tokens, const [
            SurfaceColor.muted,
            SurfaceBorder.baseline,
            SurfacePadding.sm,
            SurfaceShadow.none,
            SurfaceShape.roundedXsm,
          ])
          .copyWith(padding: EdgeInsets.all(tokens.spaceLayoutGapSm)),
      child: Column(
        spacing: tokens.spaceLayoutGapXsm,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            spacing: tokens.spaceLayoutGapSm,
            children: [
              Text(
                '${index + 1}.',
                style: textStyle.resolve(tokens, const [
                  TextSize.label,
                  TextWeight.heavy,
                  TextColor.muted,
                ]),
              ),
              Expanded(
                child:
                    valueChild ??
                    MarkdownText(
                      data: value,
                      onChanged: onAnswerChanged,
                      mode: MarkdownTextMode.input,
                      placeholder: 'Accepted answer...',
                      variants: const [
                        TextFieldSize.labelLarge,
                        TextFieldFrame.outline,
                      ],
                    ),
              ),
            ],
          ),
          Row(
            spacing: tokens.spaceLayoutGapSm,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Button.icon(
                tokens: tokens,
                icon: Icons.keyboard_arrow_up_rounded,
                onPressed: canMoveUp ? onMoveUp : null,
              ),
              Button.icon(
                tokens: tokens,
                icon: Icons.keyboard_arrow_down_rounded,
                onPressed: canMoveDown ? onMoveDown : null,
              ),
              Button.icon(
                tokens: tokens,
                icon: Icons.delete_rounded,
                onPressed: canRemove ? onRemove : null,
              ),
            ],
          ),
          SegmentedControl<CasingType>(
            isScrollable: true,
            value: casingType,
            enableGradient: true,
            options: [
              for (final type in CasingType.values)
                SegmentOption(value: type, label: type.label),
            ],
            onChanged: onCasingTypeChanged,
          ),
        ],
      ),
    );
  }
}
