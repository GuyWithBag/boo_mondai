import 'package:boo_mondai/shared/theme/theme.barrel.dart';
import 'package:boo_mondai/variant_styles/variant_styles.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class StudyCardFrame extends StatelessWidget {
  const StudyCardFrame({
    super.key,
    required this.child,
    this.tone = SurfaceTone.surface,
    this.maxWidth = 480,
  });

  final Widget child;
  final SurfaceTone tone;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth.w),
      child: SizedBox(
        width: double.infinity,
        height: 540.h,
        child: Surface(
          style: surfaceStyle.resolve(tokens, [tone]),
          child: child,
        ),
      ),
    );
  }
}
