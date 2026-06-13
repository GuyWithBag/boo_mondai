import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        ChangeReviewActions,
        ChangeReviewCard,
        ChangeReviewController, // Changed from Store
        ChangeSummaryChips;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

class ChangeReviewPage extends StatelessWidget {
  const ChangeReviewPage({super.key, required this.planId});

  final String planId;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final controller = context.watch<ChangeReviewController>();
    final plan = controller.planById(planId);

    // If the plan is gone (e.g. they already applied/discarded), pop back safely.
    if (plan == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.canPop()) context.pop();
      });
      return Scaffold(backgroundColor: tokens.backgroundPage);
    }

    return Scaffold(
      backgroundColor: tokens.backgroundPage,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.all(tokens.spacePanelPaddingSm.r),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.sync_rounded,
                            size: 52.sp,
                            color: tokens.textMuted,
                          ),
                          SizedBox(height: tokens.spacePanelGapSm.h),
                          Text(
                            plan.title,
                            style: TextStyle(
                              color: tokens.textPrimary,
                              fontFamily: tokens.fontFamily,
                              fontSize: tokens.textSizeHeader.sp,
                              fontWeight: tokens.fontWeightTextHeavy,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Review changes before applying',
                            style: TextStyle(
                              color: tokens.textSecondary,
                              fontFamily: tokens.fontFamily,
                              fontSize: tokens.textSizeLabel.sp,
                              fontWeight: tokens.fontWeightTextStrong,
                            ),
                          ),
                          SizedBox(height: tokens.spacePanelGapMd.h),
                          ChangeSummaryChips(plan: plan),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: tokens.spacePanelPaddingSm.r,
                    ),
                    sliver: SliverList.separated(
                      itemCount: plan.changes.length,
                      separatorBuilder: (_, _) =>
                          SizedBox(height: tokens.spacePanelGapSm.h),
                      itemBuilder: (context, index) {
                        return ChangeReviewCard(change: plan.changes[index]);
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: tokens.spacePanelPadding.h),
                  ),
                ],
              ),
            ),
            ChangeReviewActions(
              onBack: () => context.pop(),
              onDiscard: () {
                context.read<ChangeReviewController>().cancel(plan.id);
                context.pop(); // Immediately return to Decks
              },
              onLooksGood: () {
                context.read<ChangeReviewController>().apply(plan.id);
                context.pop(); // Immediately return to Decks
              },
              // We assume if they are on this screen, it's ready to review
              showLooksGood: true,
            ),
          ],
        ),
      ),
    );
  }
}
