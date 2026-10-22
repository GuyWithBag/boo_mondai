import 'package:boo_mondai/lib.barrel.dart'
    show AppTokens, ChangeTrackerEntry, ChangeType, ChangeTrackerHelper;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:theme_variants/theme_variants.dart';

/// Compact added/modified/removed counts for a tracked entry.
///
/// Used by review and sync surfaces to give a quick summary before the detailed
/// [ChangedEntity] list.
class ChangeTrackerSummaryChips extends StatelessWidget {
  /// Creates summary chips for [entry].
  const ChangeTrackerSummaryChips({super.key, required this.entry});

  /// Entry whose change counts should be summarized.
  final ChangeTrackerEntry<Object?> entry;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 10.w,
      runSpacing: 8.h,
      children: [
        for (final type in const [
          ChangeType.added,
          ChangeType.modified,
          ChangeType.removed,
        ])
          _SummaryChip(
            type: type,
            count: ChangeTrackerHelper.getTypeCount(entry, type),
          ),
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
    final colors = ChangeTrackerHelper.getTypeChipColors(tokens, type);
    final prefix = ChangeTrackerHelper.getTypePrefix(type);
    final label = ChangeTrackerHelper.getTypeLabel(type);

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
