import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        ChangeReviewActions,
        ChangeReviewCard,
        ChangeReviewCompleteView,
        ChangeReviewLoadingView,
        ChangeReviewPlan,
        ChangeReviewStatus,
        ChangeReviewStore,
        ChangeSummaryChips,
        ErrorState;
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
    return ChangeNotifierProvider.value(
      value: ChangeReviewStore.instance,
      child: _ChangeReviewView(planId: planId),
    );
  }
}

class _ChangeReviewView extends StatelessWidget {
  const _ChangeReviewView({required this.planId});

  final String planId;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final store = context.watch<ChangeReviewStore>();
    final plan = store.planById(planId);

    if (plan == null) {
      return Scaffold(
        backgroundColor: tokens.backgroundPage,
        body: ErrorState(exception: Exception('Change review plan not found.')),
      );
    }

    return Scaffold(
      backgroundColor: tokens.backgroundPage,
      body: SafeArea(
        child: switch (plan.status) {
          ChangeReviewStatus.previewing ||
          ChangeReviewStatus.applying => ChangeReviewLoadingView(
            plan: plan,
            onCancel: () => store.cancel(plan.id),
          ),
          ChangeReviewStatus.completed => ChangeReviewCompleteView(
            plan: plan,
            onShowResults: () =>
                store.update(plan.id, status: ChangeReviewStatus.results),
          ),
          ChangeReviewStatus.failed => ErrorState(
            exception: Exception(plan.errorMessage ?? 'Change review failed.'),
          ),
          _ => _ChangeReviewDetails(plan: plan),
        },
      ),
    );
  }
}

class _ChangeReviewDetails extends StatelessWidget {
  const _ChangeReviewDetails({required this.plan});

  final ChangeReviewPlan plan;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    return Column(
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
            ChangeReviewStore.instance.cancel(plan.id);
            context.pop();
          },
          onLooksGood: () {
            ChangeReviewStore.instance.apply(plan.id);
          },
          showLooksGood: plan.status == ChangeReviewStatus.reviewing,
        ),
      ],
    );
  }
}
