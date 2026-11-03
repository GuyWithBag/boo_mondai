import 'package:boo_mondai/lib.barrel.dart'
    show HeaderBadgeTone, headerBadgeStyle, AppTokens, ThemeController;
import 'package:flutter/material.dart';

class HeaderBadge extends StatelessWidget {
  const HeaderBadge({
    required this.label,
    this.tone = HeaderBadgeTone.brand,
    super.key,
  });

  final String label;
  final HeaderBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeController.tokens;
    final style = headerBadgeStyle.resolve(tokens, [tone]);

    return ChipTheme(
      data: style,
      child: Chip(
        label: Text(label.toUpperCase()),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
