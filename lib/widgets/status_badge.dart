import 'package:flutter/material.dart';
import 'package:theme_variants/theme_variants.dart';

import 'package:boo_mondai/shared/shared.barrel.dart';
import '../variant_styles/variant_styles.barrel.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.label,
    this.tone = StatusBadgeTone.brand,
    super.key,
  });

  final String label;
  final StatusBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final style = statusBadgeStyle.resolve(tokens, [tone]);

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
