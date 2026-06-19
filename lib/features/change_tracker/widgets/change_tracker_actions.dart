import 'package:boo_mondai/lib.barrel.dart' show AppTokens, Button;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

/// Bottom action bar for the change-review page.
class ChangeTrackerActions extends StatelessWidget {
  /// Creates action controls for navigation, discard, and apply.
  const ChangeTrackerActions({
    super.key,
    required this.onBack,
    required this.onDiscard,
    required this.onLooksGood,
    required this.showLooksGood,
  });

  /// Called when the user returns without changing plan state.
  final VoidCallback onBack;

  /// Called when the user discards/cancels the plan.
  final VoidCallback onDiscard;

  /// Called when the user accepts and applies the plan.
  final VoidCallback onLooksGood;

  /// Whether the apply action should be visible.
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
