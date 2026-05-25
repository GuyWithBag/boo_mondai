import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

import 'package:boo_mondai/shared/shared.barrel.dart';
import '../variant_styles/variant_styles.barrel.dart';

class MetaLabel extends StatelessWidget {
  const MetaLabel({
    required this.label,
    this.icon,
    this.tooltip,
    this.tone = MetaLabelTone.muted,
    super.key,
  });

  final String label;
  final IconData? icon;
  final String? tooltip;
  final MetaLabelTone tone;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final style = metaLabelStyle.resolve(tokens, [tone]);

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          IconTheme(data: style.iconTheme, child: Icon(icon)),
          SizedBox(width: 4.w),
        ],
        Text(label, style: style.textStyle),
      ],
    );

    if (tooltip == null) return content;

    return Tooltip(message: tooltip!, child: content);
  }
}
