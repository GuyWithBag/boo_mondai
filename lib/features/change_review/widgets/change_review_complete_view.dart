import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, Button, ChangeReviewPlan, ChangeSummaryChips;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:theme_variants/theme_variants.dart';

class ChangeReviewCompleteView extends StatelessWidget {
  const ChangeReviewCompleteView({
    super.key,
    required this.plan,
    required this.onShowResults,
  });

  final ChangeReviewPlan plan;
  final VoidCallback onShowResults;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Center(
      child: Padding(
        padding: EdgeInsets.all(tokens.spacePanelPadding.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sync_rounded, size: 76.sp, color: tokens.textMuted),
            SizedBox(height: tokens.spacePanelGapMd.h),
            Text(
              '${plan.title} Complete!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: tokens.textPrimary,
                fontFamily: tokens.fontFamily,
                fontSize: tokens.textSizeHeader.sp,
                fontWeight: tokens.fontWeightTextStrong,
              ),
            ),
            SizedBox(height: tokens.spacePanelGapMd.h),
            ChangeSummaryChips(plan: plan),
            SizedBox(height: tokens.spacePanelGapLg.h),
            Row(
              children: [
                Expanded(
                  child: Button(
                    onPressed: onShowResults,
                    child: const Text('SHOW RESULTS'),
                  ),
                ),
                SizedBox(width: tokens.spacePanelGapSm.w),
                Expanded(
                  child: Button(
                    onPressed: () => context.pop(),
                    child: const Text('DONE'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
