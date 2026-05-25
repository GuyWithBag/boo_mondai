import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

import 'package:boo_mondai/shared/shared.barrel.dart';
import '../variant_styles/variant_styles.barrel.dart';

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
    final tokens = context.themeTokens<AppTokens>();
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
