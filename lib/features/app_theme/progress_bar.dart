import 'package:boo_mondai/lib.barrel.dart' show AppTokens;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({required this.value, super.key});

  final double value;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final clampedValue = value.clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        height: 14.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: tokens.colorMuted),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: clampedValue,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: tokens.colorPrimary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 4.h,
                    margin: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
