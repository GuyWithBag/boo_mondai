import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        ChangeTrackerController,
        ChangeTrackerActions,
        ChangeTrackerCard,
        ChangeTrackerSummaryChips;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

/// Full-page UI for reviewing a pending tracked change entry.
class ChangeTrackerPage extends StatelessWidget {
  /// Creates a page that resolves and displays the entry with [entryId].
  const ChangeTrackerPage({super.key, required this.entryId});

  /// Id of the entry managed by [ChangeTrackerController].
  final String entryId;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final controller = context.watch<ChangeTrackerController>();
    final entry = controller.entryById(entryId);

    if (entry == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.canPop()) context.pop();
      });
      return Scaffold(backgroundColor: tokens.colorScaffoldBackground);
    }

    return Scaffold(
      backgroundColor: tokens.colorScaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.all(tokens.spaceLayoutPadding.r),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.sync_rounded,
                            size: 52.sp,
                            color: tokens.colorTextMuted,
                          ),
                          SizedBox(height: tokens.spaceLayoutGapSm.h),
                          Text(
                            entry.title,
                            style: TextStyle(
                              color: tokens.colorTextBaseline,
                              fontFamily: tokens.fontFamily,
                              fontSize: tokens.textSizeHeader.sp,
                              fontWeight: tokens.fontWeightTextHeavy,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Review changes before applying',
                            style: TextStyle(
                              color: tokens.colorTextMuted,
                              fontFamily: tokens.fontFamily,
                              fontSize: tokens.textSizeLabel.sp,
                              fontWeight: tokens.fontWeightTextStrong,
                            ),
                          ),
                          SizedBox(height: tokens.spaceLayoutGapMd.h),
                          ChangeTrackerSummaryChips(entry: entry),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: tokens.spaceLayoutPadding.r,
                    ),
                    sliver: SliverList.separated(
                      itemCount: entry.changes.length,
                      separatorBuilder: (_, _) =>
                          SizedBox(height: tokens.spaceLayoutGapSm.h),
                      itemBuilder: (context, index) {
                        return ChangeTrackerCard(change: entry.changes[index]);
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: tokens.spaceLayoutPadding.h),
                  ),
                ],
              ),
            ),
            ChangeTrackerActions(
              onBack: () => context.pop(),
              onDiscard: () {
                context.read<ChangeTrackerController>().cancel(entry.id);
                context.pop();
              },
              onLooksGood: () {
                context.read<ChangeTrackerController>().apply(entry.id);
                context.pop();
              },
              showLooksGood: true,
            ),
          ],
        ),
      ),
    );
  }
}
