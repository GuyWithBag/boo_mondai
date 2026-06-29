import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button, buttonStyle,
        ButtonSize,
        ButtonPadding,
        textStyle,
        TextSize,
        TextWeight;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:theme_variants/theme_variants.dart';

class ReviewAllCard extends StatelessWidget {
  const ReviewAllCard({super.key, required this.dueCount});

  final int dueCount;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final canReview = dueCount > 0;

    return Material(
      color: tokens.colorSurfaceBackground,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: tokens.colorBorderNeutralSubtle,
          width: tokens.borderWidthDefault.w,
        ),
        borderRadius: BorderRadius.circular(tokens.radiusSurfaceXsm.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spaceLayoutPadding.r,
          vertical: tokens.spaceLayoutPadding.r,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'You have $dueCount card${dueCount == 1 ? '' : 's'} Due',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle.resolve(tokens, const [
                      TextSize.header,
                      TextWeight.strong,
                    ]),
                  ),
                  SizedBox(height: tokens.spaceLayoutGapSm.h),
                  Text(
                    '{Random Motivational Phrase}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle.resolve(tokens, const [
                      TextSize.label,
                      TextWeight.strong,
                    ]),
                  ),
                ],
              ),
            ),
            SizedBox(width: tokens.spaceLayoutGapLg.w),
            Button(
              onPressed: canReview
                  ? () => context.push('/review/session')
                  : null,

              style: buttonStyle.resolve(tokens, const [ButtonSize.lg, ButtonPadding.lg]),
              child: const Text('REVIEW ALL?'),
            ),
          ],
        ),
      ),
    );
  }
}
