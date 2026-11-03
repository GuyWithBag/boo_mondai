import 'package:boo_mondai/features/features.barrel.dart';
import 'package:boo_mondai/lib.barrel.dart' show AppTokens, ThemeController;
import 'package:flutter/material.dart'
    show
        StatelessWidget,
        Widget,
        BuildContext,
        Expanded,
        EdgeInsets,
        Divider,
        Padding,
        Row;

class LabeledDivider extends StatelessWidget {
  const LabeledDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeController.tokens;
    return Row(
      children: [
        Expanded(child: Divider(thickness: tokens.borderWidthDefault)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: tokens.spaceLayoutGapSm),
          child: MetaLabel(label: label),
        ),
        Expanded(child: Divider(thickness: tokens.borderWidthDefault)),
      ],
    );
  }
}
