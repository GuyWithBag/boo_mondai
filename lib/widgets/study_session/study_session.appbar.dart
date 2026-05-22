import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

import 'package:boo_mondai/shared/theme/theme.barrel.dart';
import '../../variant_styles/variant_styles.barrel.dart';
import 'progress_bar.dart';
import '../tactile_button.dart';

class StudySessionAppbar extends StatelessWidget {
  const StudySessionAppbar({
    required this.current,
    required this.total,
    required this.progress,
    required this.onClose,
    super.key,
  });

  final int current;
  final int total;
  final double progress;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: tokens.backgroundPage,
        border: Border(
          bottom: BorderSide(
            color: tokens.borderNeutralSubtle.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          TactileButton.icon(icon: Icons.close, onPressed: onClose),
          SizedBox(width: 18.w),
          Expanded(child: ProgressBar(value: progress)),
          SizedBox(width: 18.w),
          Text(
            '$current / $total',
            style: appTextStyle.resolve(tokens, [
              TextSize.labelSmall,
              TextWeight.heavy,
              TextTone.muted,
            ]),
          ),
        ],
      ),
    );
  }
}
