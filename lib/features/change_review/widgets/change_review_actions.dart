import 'package:boo_mondai/lib.barrel.dart' show AppTokens, Button;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class ChangeReviewActions extends StatelessWidget {
  const ChangeReviewActions({
    super.key,
    required this.onBack,
    required this.onDiscard,
    required this.onLooksGood,
    required this.showLooksGood,
  });

  final VoidCallback onBack;
  final VoidCallback onDiscard;
  final VoidCallback onLooksGood;
  final bool showLooksGood;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return DecoratedBox(
      decoration: BoxDecoration(color: tokens.colorScaffoldBackground),
      child: Padding(
        padding: EdgeInsets.all(tokens.spaceLayoutPadding.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: Button(onPressed: onBack, child: const Text('BACK')),
            ),
            SizedBox(height: tokens.spaceLayoutGapSm.h),
            Row(
              children: [
                Expanded(
                  child: Button(
                    onPressed: onDiscard,
                    child: const Text('DISCARD'),
                  ),
                ),
                if (showLooksGood) ...[
                  SizedBox(width: tokens.spaceLayoutGapSm.w),
                  Expanded(
                    child: Button(
                      onPressed: onLooksGood,
                      child: const Text('LOOKS GOOD'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
