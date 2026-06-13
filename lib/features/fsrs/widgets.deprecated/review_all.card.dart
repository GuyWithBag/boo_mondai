import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonSize,
        ButtonTone,
        appTextStyle,
        TextSize,
        TextTone,
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
      color: tokens.backgroundSurface,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: tokens.borderNeutralSubtle,
          width: tokens.borderWidthDefault.w,
        ),
        borderRadius: BorderRadius.circular(tokens.radiusSurfaceSm.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: tokens.spacePanelPadding.r,
          vertical: tokens.spacePanelPaddingSm.r,
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
                    style: appTextStyle.resolve(tokens, const [
                      TextSize.header,
                      TextWeight.strong,
                      TextTone.primary,
                    ]),
                  ),
                  SizedBox(height: tokens.spacePanelGapSm.h),
                  Text(
                    '{Random Motivational Phrase}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: appTextStyle.resolve(tokens, const [
                      TextSize.label,
                      TextWeight.strong,
                      TextTone.primary,
                    ]),
                  ),
                ],
              ),
            ),
            SizedBox(width: tokens.spacePanelGapLg.w),
            Button(
              onPressed: canReview
                  ? () => context.push('/review/session')
                  : null,
              tone: ButtonTone.ghost,
              size: ButtonSize.lg,
              child: const Text('REVIEW ALL?'),
            ),
          ],
        ),
      ),
    );
  }
}
