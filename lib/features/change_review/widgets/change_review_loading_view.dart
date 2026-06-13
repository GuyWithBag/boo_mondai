import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, Button, ChangeReviewPlan, ProgressBar;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class ChangeReviewLoadingView extends StatelessWidget {
  const ChangeReviewLoadingView({
    super.key,
    required this.plan,
    required this.onCancel,
  });

  final ChangeReviewPlan plan;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final progress = plan.progress ?? 0;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(tokens.spacePanelPadding.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sync_rounded, size: 76.sp, color: tokens.textMuted),
            SizedBox(height: tokens.spacePanelGapMd.h),
            Text(
              plan.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: tokens.textPrimary,
                fontFamily: tokens.fontFamily,
                fontSize: tokens.textSizeHeader.sp,
                fontWeight: tokens.fontWeightTextStrong,
              ),
            ),
            SizedBox(height: tokens.spacePanelGapMd.h),
            Text(
              '${(progress * 100).round()}%',
              style: TextStyle(
                color: tokens.textPrimary,
                fontFamily: tokens.fontFamily,
                fontSize: tokens.textSizeLabelLarge.sp,
                fontWeight: tokens.fontWeightTextHeavy,
              ),
            ),
            SizedBox(height: tokens.spacePanelGapMd.h),
            ProgressBar(value: progress),
            SizedBox(height: tokens.spacePanelGapLg.h),
            SizedBox(
              width: double.infinity,
              child: Button(onPressed: onCancel, child: const Text('CANCEL')),
            ),
          ],
        ),
      ),
    );
  }
}
