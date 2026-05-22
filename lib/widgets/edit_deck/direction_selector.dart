import 'package:boo_mondai/lib.barrel.dart';
import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

class CardTypeSelector extends StatelessWidget {
  const CardTypeSelector({
    required this.selected,
    required this.hint,
    required this.onChanged,
    super.key,
  });

  final CardType selected;
  final String hint;
  final ValueChanged<CardType> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    const options = [
      SegmentOption(value: CardType.normal, label: 'Normal'),
      SegmentOption(value: CardType.reversed, label: 'Reversed'),
      SegmentOption(value: CardType.both, label: 'Both Ways'),
    ];

    return Surface(
      style: surfaceStyle.resolve(tokens, const [SurfaceTone.surface]),
      child: Wrap(
        spacing: 18,
        runSpacing: 18,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 310,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Study Direction',
                  style: appTextStyle
                      .resolve(tokens, [
                        TextSize.labelLarge,
                        TextWeight.heavy,
                        TextTone.primary,
                      ])
                      .copyWith(fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  hint,
                  style: appTextStyle.resolve(tokens, [
                    TextSize.label,
                    TextWeight.body,
                    TextTone.secondary,
                  ]),
                ),
              ],
            ),
          ),
          SegmentedControl<CardType>(
            options: options,
            value: selected,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
