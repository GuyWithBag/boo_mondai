import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, ChangeLog, ChangeType, ChangeFieldDiffView;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class ChangeReviewCard extends StatelessWidget {
  const ChangeReviewCard({super.key, required this.change});

  final ChangeLog change;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final iconText = switch (change.type) {
      ChangeType.added => '+',
      ChangeType.modified => '~',
      ChangeType.removed => '-',
      ChangeType.skipped => '',
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.backgroundSurface,
        borderRadius: BorderRadius.circular(tokens.radiusSurfaceSm.r),
        border: Border.all(
          color: tokens.borderNeutralSubtle,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(tokens.spacePanelPaddingSm.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 28.w,
                  child: Text(
                    iconText,
                    style: TextStyle(
                      color: _foreground(tokens, change.type),
                      fontFamily: tokens.fontFamily,
                      fontSize: tokens.textSizeHeader.sp,
                      fontWeight: tokens.fontWeightTextHeavy,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        change.title,
                        style: TextStyle(
                          color: tokens.textPrimary,
                          fontFamily: tokens.fontFamily,
                          fontSize: tokens.textSizeLabelLarge.sp,
                          fontWeight: tokens.fontWeightTextStrong,
                        ),
                      ),
                      if (change.subtitle != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          change.subtitle!,
                          style: TextStyle(
                            color: tokens.textSecondary,
                            fontFamily: tokens.fontFamily,
                            fontSize: tokens.textSizeLabel.sp,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (change.fields.isNotEmpty) ...[
              SizedBox(height: tokens.spacePanelGapMd.h),
              for (final field in change.fields)
                ChangeFieldDiffView(diff: field, type: change.type),
            ],
          ],
        ),
      ),
    );
  }
}

Color _foreground(AppTokens tokens, ChangeType type) {
  return switch (type) {
    ChangeType.added => tokens.actionSuccess,
    ChangeType.modified => tokens.ratingHardText,
    ChangeType.removed => tokens.ratingAgainText,
    ChangeType.skipped => tokens.textSecondary,
  };
}
