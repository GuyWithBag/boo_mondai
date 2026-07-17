import 'package:boo_mondai/features/app_theme/surface.variant.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Streak,
        TextSize,
        TextWeight,
        surfaceStyle,
        textStyle,
        Elevated;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class StreaksCard extends StatelessWidget {
  const StreaksCard({super.key, required this.streak});

  final Streak? streak;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Elevated(
      child: Surface(
        style: surfaceStyle.resolve(tokens, const [
          SurfaceColor.streak,
          SurfaceShadow.tactile,
        ]),
        child: Row(
          spacing: tokens.spaceLayoutGapMd,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_fire_department_outlined, size: 45.sp),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: tokens.spaceLayoutGapSm,
              children: [
                Text(
                  '${streak?.currentStreak ?? 0}',
                  style: textStyle.resolve(tokens, const [
                    TextSize.header2,
                    TextWeight.heavy,
                  ]),
                ),
                Text(
                  'Day Streak',
                  style: textStyle.resolve(tokens, const [TextSize.label]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
