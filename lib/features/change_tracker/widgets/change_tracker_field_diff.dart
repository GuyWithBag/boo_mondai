import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, ChangedProperty, ChangeType;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

/// Renders a field-level before/after diff.
class ChangeTrackerFieldDiff extends StatelessWidget {
  /// Creates a diff view for [diff], styled according to [type].
  const ChangeTrackerFieldDiff({
    super.key,
    required this.diff,
    required this.type,
  });

  /// Field diff to render.
  final ChangedProperty diff;

  /// Parent change type used to choose visual treatment.
  final ChangeType type;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final before = diff.before?.toString();
    final after = diff.after?.toString();

    return Padding(
      padding: EdgeInsets.only(bottom: tokens.spaceLayoutGapMd.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            diff.propertyLabel,
            style: TextStyle(
              color: tokens.colorTextBaseline,
              fontFamily: tokens.fontFamily,
              fontSize: tokens.textSizeLabelLarge.sp,
              fontWeight: tokens.fontWeightTextStrong,
            ),
          ),
          SizedBox(height: 8.h),
          Divider(color: tokens.colorBorderNeutralSubtle, thickness: 1.5.h),
          if (before != null && before.isNotEmpty) ...[
            Text(
              before,
              style: TextStyle(
                color: tokens.colorTextMuted,
                fontFamily: tokens.fontFamily,
                fontSize: tokens.textSizeLabel.sp,
                decoration: type == ChangeType.modified
                    ? TextDecoration.lineThrough
                    : null,
              ),
            ),
            SizedBox(height: 6.h),
          ],
          if (after != null && after.isNotEmpty)
            Text(
              after,
              style: TextStyle(
                color: tokens.colorTextBaseline,
                fontFamily: tokens.fontFamily,
                fontSize: tokens.textSizeLabel.sp,
                fontWeight: tokens.fontWeightTextStrong,
              ),
            ),
        ],
      ),
    );
  }
}
