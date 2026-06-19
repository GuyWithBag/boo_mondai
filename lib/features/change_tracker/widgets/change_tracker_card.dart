import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, ChangeRecord, ChangeTrackerFieldDiff, ChangeTrackerHelper;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

/// Card that summarizes one change and its field diffs.
class ChangeTrackerCard extends StatelessWidget {
  /// Creates a card for one change entry.
  const ChangeTrackerCard({super.key, required this.change});

  /// Change entry to display.
  final ChangeRecord change;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final iconText = ChangeTrackerHelper.typePrefix(change.type);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.colorSurfaceBackground,
        borderRadius: BorderRadius.circular(tokens.radiusSurfaceXsm.r),
        border: Border.all(
          color: tokens.colorBorderNeutralSubtle,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(tokens.spaceLayoutPadding.r),
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
                      color: ChangeTrackerHelper.typeForeground(
                        tokens,
                        change.type,
                      ),
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
                          color: tokens.colorTextBaseline,
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
                            color: tokens.colorTextMuted,
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
              SizedBox(height: tokens.spaceLayoutGapMd.h),
              for (final field in change.fields)
                ChangeTrackerFieldDiff(diff: field, type: change.type),
            ],
          ],
        ),
      ),
    );
  }
}
