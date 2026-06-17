import 'package:boo_mondai/lib.barrel.dart'
    show MetaLabelTone, AppTokens, metaLabelStyle;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:theme_variants/theme_variants.dart';

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
      spacing: tokens.spaceLayoutGapSm.w,
      children: [
        if (icon != null) ...[
          IconTheme(data: style.iconTheme, child: Icon(icon)),
        ],
        Text(label, style: style.textStyle),
      ],
    );

    if (tooltip == null) return content;

    return Tooltip(message: tooltip!, child: content);
  }
}
