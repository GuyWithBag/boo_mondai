import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, ChangeFieldDiff, ChangeType;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class ChangeFieldDiffView extends StatelessWidget {
  const ChangeFieldDiffView({
    super.key,
    required this.diff,
    required this.type,
  });

  final ChangeFieldDiff diff;
  final ChangeType type;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final before = diff.before?.toString();
    final after = diff.after?.toString();

    return Padding(
      padding: EdgeInsets.only(bottom: tokens.spacePanelGapMd.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            diff.field,
            style: TextStyle(
              color: tokens.textPrimary,
              fontFamily: tokens.fontFamily,
              fontSize: tokens.textSizeLabelLarge.sp,
              fontWeight: tokens.fontWeightTextStrong,
            ),
          ),
          SizedBox(height: 8.h),
          Divider(color: tokens.borderNeutralSubtle, thickness: 1.5.h),
          if (before != null && before.isNotEmpty) ...[
            Text(
              before,
              style: TextStyle(
                color: tokens.textMuted,
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
                color: tokens.textPrimary,
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
