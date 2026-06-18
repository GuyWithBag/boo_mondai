// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/sync_page.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        ChangeReviewPlan,
        AppTokens,
        ChangeReviewStatus,
        ProgressBar,
        ChangeSummaryChips,
        Button,
        ButtonColor;
import 'package:flutter/material.dart'
    show
        SizedBox,
        TextStyle,
        StatelessWidget,
        VoidCallback,
        Widget,
        BuildContext,
        BoxConstraints,
        Text,
        EdgeInsets,
        MainAxisSize,
        Icons,
        Icon,
        TextAlign,
        Expanded,
        Row,
        Column,
        ConstrainedBox,
        Padding,
        Center,
        SafeArea,
        Scaffold;
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:theme_variants/theme_variants.dart' show ThemeVariantsContext;

class SyncPage extends StatelessWidget {
  const SyncPage({
    super.key,
    required this.plan,
    required this.onViewChanges,
    required this.onApply,
    required this.onDiscard,
  });

  final ChangeReviewPlan plan;
  final VoidCallback onViewChanges;
  final VoidCallback onApply;
  final VoidCallback onDiscard;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final progress = (plan.progress ?? 0).clamp(0.0, 1.0);

    final isAlreadyUpToDate = plan.status == ChangeReviewStatus.alreadyUpToDate;
    final isReviewing = plan.status == ChangeReviewStatus.reviewing;
    final isComplete =
        plan.status == ChangeReviewStatus.completed ||
        plan.status == ChangeReviewStatus.results ||
        isReviewing;

    // ── "Already up to date" state ───────────────────────────────────────────
    if (isAlreadyUpToDate) {
      return Scaffold(
        backgroundColor: tokens.colorScaffoldBackground,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(tokens.spaceLayoutPadding.r),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 76,
                      color: tokens.colorTextMuted,
                    ),
                    SizedBox(height: tokens.spaceLayoutGapMd.h),
                    Text(
                      'Everything is already up to date',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: tokens.colorTextBaseline,
                        fontFamily: tokens.fontFamily,
                        fontSize: tokens.textSizeHeader.sp,
                        fontWeight: tokens.fontWeightTextStrong,
                      ),
                    ),
                    SizedBox(height: tokens.spaceLayoutGapSm.h),
                    Text(
                      'No changes to apply.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: tokens.colorTextMuted,
                        fontFamily: tokens.fontFamily,
                        fontSize: tokens.textSizeLabelLarge.sp,
                        fontWeight: tokens.fontWeightTextStrong,
                      ),
                    ),
                    SizedBox(height: tokens.spaceLayoutGapLg.h),
                    SizedBox(
                      width: double.infinity,
                      child: Button(
                        onPressed: onDiscard,
                        child: const Text('CANCEL'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // ── Normal sync states (loading → reviewing → complete) ──────────────────
    return Scaffold(
      backgroundColor: tokens.colorScaffoldBackground,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(tokens.spaceLayoutPadding.r),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.sync_rounded,
                    size: 76,
                    color: tokens.colorTextMuted,
                  ),
                  SizedBox(height: tokens.spaceLayoutGapMd.h),
                  Text(
                    isComplete ? 'Sync Complete!' : 'Syncing',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: tokens.colorTextBaseline,
                      fontFamily: tokens.fontFamily,
                      fontSize: tokens.textSizeHeader.sp,
                      fontWeight: tokens.fontWeightTextStrong,
                    ),
                  ),
                  SizedBox(height: tokens.spaceLayoutGapSm.h),
                  Text(
                    isComplete
                        ? isReviewing
                              ? 'Review changes before applying.'
                              : 'Sync processed successfully.'
                        : '${(progress * 100).round()}%',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: tokens.colorTextMuted,
                      fontFamily: tokens.fontFamily,
                      fontSize: tokens.textSizeLabelLarge.sp,
                      fontWeight: tokens.fontWeightTextStrong,
                    ),
                  ),
                  if (!isComplete) ...[
                    SizedBox(height: tokens.spaceLayoutGapMd.h),
                    ProgressBar(value: progress),
                  ] else ...[
                    SizedBox(height: tokens.spaceLayoutGapMd.h),
                    ChangeSummaryChips(plan: plan),
                  ],
                  SizedBox(height: tokens.spaceLayoutGapLg.h),
                  if (isComplete) ...[
                    Row(
                      children: [
                        Expanded(
                          child: Button(
                            onPressed: onViewChanges,
                            child: const Text('VIEW CHANGES'),
                          ),
                        ),
                        SizedBox(width: tokens.spaceLayoutGapSm.w),
                        Expanded(
                          child: Button(
                            variants: const [
                              ButtonColor.primary,
                              ButtonColor.primary,
                            ],
                            onPressed: onApply,
                            child: const Text('APPLY'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: tokens.spaceLayoutGapSm.h),
                    SizedBox(
                      width: double.infinity,
                      child: Button(
                        onPressed: onDiscard,
                        child: const Text('DISCARD'),
                      ),
                    ),
                  ] else ...[
                    SizedBox(
                      width: double.infinity,
                      child: Button(
                        onPressed: onDiscard,
                        child: const Text('CANCEL'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
