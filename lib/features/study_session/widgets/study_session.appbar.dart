import 'package:boo_mondai/lib.barrel.dart'
    show
        StudySessionController,
        AppTokens,
        Button,
        ProgressBar,
        textStyle,
        TextSize,
        TextWeight,
        TextColor;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class StudySessionAppbar extends StatelessWidget {
  const StudySessionAppbar({
    super.key,
    required this.onClose,
    required this.controller,
  });

  final VoidCallback onClose;
  final StudySessionController controller;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: tokens.colorScaffoldBackground,
        border: Border(
          bottom: BorderSide(
            color: tokens.colorBorderNeutralSubtle.withValues(alpha: 0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          Button.icon(icon: Icons.close, onPressed: onClose),
          SizedBox(width: 18.w),
          Expanded(
            child: ProgressBar(value: controller.getProgressPercentage()),
          ),
          SizedBox(width: 18.w),
          Text(
            '${controller.currentIndex} / ${controller.queue.length}',
            style: textStyle.resolve(tokens, [
              TextSize.labelSmall,
              TextWeight.heavy,
              TextColor.muted,
            ]),
          ),
        ],
      ),
    );
  }
}
