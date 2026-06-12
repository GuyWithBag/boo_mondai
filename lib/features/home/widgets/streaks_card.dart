import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Streak,
        SurfaceBorder,
        SurfaceShape,
        SurfaceTone,
        surfaceStyle;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class StreaksCard extends StatelessWidget {
  const StreaksCard({super.key, required this.streak});

  final Streak? streak;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Surface(
      style: surfaceStyle.resolve(tokens, const [
        SurfaceTone.muted,
        SurfaceShape.rounded,
        SurfaceBorder.none,
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_fire_department_outlined, size: 34.sp),
          SizedBox(width: 18.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${streak?.currentStreak ?? 0}',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: tokens.fontWeightTextHeavy,
                  height: 1,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'Day Streak',
                style: TextStyle(
                  fontSize: tokens.textSizeLabel.sp,
                  fontWeight: tokens.fontWeightTextStrong,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
