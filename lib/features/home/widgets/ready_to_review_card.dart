import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonSize,
        ButtonVariant,
        ButtonColor,
        SurfaceTone,
        surfaceStyle;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class ReadyToReviewCard extends StatelessWidget {
  const ReadyToReviewCard({
    super.key,
    required this.dueCount,
    required this.onStartSession,
  });

  final int dueCount;
  final VoidCallback onStartSession;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final canStart = dueCount > 0;

    return Surface(
      style: surfaceStyle.resolve(tokens, const [SurfaceTone.primarySoft]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ready to Review?',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: tokens.fontWeightTextHeavy,
              height: tokens.lineHeightTextTitle,
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            canStart
                ? 'You have $dueCount card${dueCount == 1 ? '' : 's'} ready for review, let\'s get to work!'
                : 'You are all caught up. Come back when more cards are due.',
            style: TextStyle(
              fontSize: tokens.textSizeLabelLarge.sp,
              fontWeight: tokens.fontWeightTextStrong,
              height: tokens.lineHeightTextBody,
            ),
          ),
          SizedBox(height: 26.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Button(
              onPressed: canStart ? onStartSession : null,
              variants: const [
                ButtonVariant.filled,
                ButtonColor.primary,
                ButtonSize.lg,
              ],
              child: const Text('START SESSION'),
            ),
          ),
        ],
      ),
    );
  }
}
