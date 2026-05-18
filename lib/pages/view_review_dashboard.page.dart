// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/review_dashboard_page.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/widgets/widgets.barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:boo_mondai/controllers/controllers.barrel.dart';
import 'package:boo_mondai/shared/shared.barrel.dart';

class ReviewDashboardPage extends HookWidget {
  const ReviewDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ReviewDashboardController>();

    useEffect(() {
      // Load stats when page opens
      Future.microtask(() => ctrl.load());
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(title: const Text('FSRS Reviews')),
      body: ListingStatesWrapper.list(
        emptyState: EmptyState(
          // Placeholder icon
          icon: Icons.abc,
          title: 'No Enrolled Cards Yet',
          message: 'Go take a drill!',
        ),
        isLoading: ctrl.isLoading,
        items: ctrl.deckStats,
        onRetry: ctrl.load,
        skeletonTile: ReviewDeckTile(),
        padding: const EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.md,
          bottom: 100, // Padding for FAB
        ),
        itemBuilder: (_, _, stat) {
          return ReviewDeckTile(stats: stat);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ctrl.totalDue > 0
          ? FloatingActionButton.extended(
              onPressed: () {
                // TODO (Phase 2): Route to the global interactive Review Session
                context.push('/review/session');
              },
              icon: const Icon(Icons.school),
              label: Text('Study All (${ctrl.totalDue} Due)'),
            )
          : null,
    );
  }
}
