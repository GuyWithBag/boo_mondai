import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, ChangeReviewPlan, ChangeType;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

class ChangeSummaryChips extends StatelessWidget {
  const ChangeSummaryChips({super.key, required this.plan});

  final ChangeReviewPlan plan;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10.w,
      runSpacing: 8.h,
      children: [
        _SummaryChip(type: ChangeType.added, count: plan.addedCount),
        _SummaryChip(type: ChangeType.modified, count: plan.modifiedCount),
        _SummaryChip(type: ChangeType.removed, count: plan.removedCount),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.type, required this.count});

  final ChangeType type;
  final int count;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final colors = _colors(tokens, type);
    final prefix = switch (type) {
      ChangeType.added => '+',
      ChangeType.modified => '~',
      ChangeType.removed => '-',
      ChangeType.skipped => '',
    };
    final label = switch (type) {
      ChangeType.added => 'Added',
      ChangeType.modified => 'Modified',
      ChangeType.removed => 'Removed',
      ChangeType.skipped => 'Skipped',
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: colors.border,
          width: tokens.borderWidthDefault.w,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
        child: Text(
          '$prefix $count $label',
          style: TextStyle(
            color: colors.foreground,
            fontFamily: tokens.fontFamily,
            fontWeight: tokens.fontWeightTextStrong,
            fontSize: tokens.textSizeLabel.sp,
          ),
        ),
      ),
    );
  }
}

({Color foreground, Color background, Color border}) _colors(
  AppTokens tokens,
  ChangeType type,
) {
  return switch (type) {
    ChangeType.added => (
      foreground: tokens.actionSuccess,
      background: tokens.actionSuccessBackground,
      border: tokens.actionSuccessBorder,
    ),
    ChangeType.modified => (
      foreground: tokens.ratingHardText,
      background: tokens.ratingHardBackground,
      border: tokens.ratingHardBorder,
    ),
    ChangeType.removed => (
      foreground: tokens.ratingAgainText,
      background: tokens.ratingAgainBackground,
      border: tokens.ratingAgainBorder,
    ),
    ChangeType.skipped => (
      foreground: tokens.textSecondary,
      background: tokens.backgroundSurface,
      border: tokens.borderNeutralSubtle,
    ),
  };
}
