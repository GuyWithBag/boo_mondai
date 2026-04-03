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
      Future.microtask(
        () => context.read<ReviewDashboardController>().loadDashboard(),
      );
      return null;
    }, const []);

    if (ctrl.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (ctrl.error != null) {
      return Scaffold(body: Center(child: Text(ctrl.error!)));
    }

    if (ctrl.deckStats.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('FSRS Reviews')),
        body: const Center(
          child: Text('No enrolled cards yet. Go take a quiz!'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('FSRS Reviews')),
      body: ListView.separated(
        padding: const EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.md,
          bottom: 100, // Padding for FAB
        ),
        itemCount: ctrl.deckStats.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, i) {
          final stat = ctrl.deckStats[i];
          return ReviewDeckTile(
            stats: stat,
            onTap: () {
              // TODO (Phase 2): Route to the new interactive Review Session for this specific deck
              context.push('/review/${stat.deckId}/session');
            },
          );
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
