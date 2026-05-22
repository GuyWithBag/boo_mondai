import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

import 'package:boo_mondai/shared/shared.barrel.dart';
import '../variant_styles/variant_styles.barrel.dart';

class PanelHeader extends StatelessWidget {
  const PanelHeader({required this.title, this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Container(
      padding: EdgeInsets.all(20.w),
      color: tokens.softGray,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: appTextStyle.resolve(tokens, [
                TextSize.labelLarge,
                TextWeight.heavy,
                TextTone.primary,
              ]),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
