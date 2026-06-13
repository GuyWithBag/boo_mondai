// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/view_deck_downloads_page.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        ChangeReviewController,
        ChangeReviewStatus,
        DownloadsTile,
        EmptyState,
        ViewDeckDownloadsAppbar,
        ViewDeckDownloadsController;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewDeckDownloadsPage extends StatelessWidget {
  const ViewDeckDownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ViewDeckDownloadsController(
        reviewController: context.read<ChangeReviewController>(),
      ),
      child: const _ViewDeckDownloadsView(),
    );
  }
}

class _ViewDeckDownloadsView extends StatelessWidget {
  const _ViewDeckDownloadsView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ViewDeckDownloadsController>();

    return Scaffold(
      appBar: const ViewDeckDownloadsAppbar(),
      body: controller.isEmpty
          ? const Center(
              child: EmptyState(
                icon: Icons.download_done_rounded,
                title: 'No downloads',
                message: 'Downloaded decks will appear here.',
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (controller.activePlans.isNotEmpty) ...[
                  for (final plan in controller.activePlans)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: DownloadsTile(
                        plan: plan,
                        progress: controller.progressForPlan(plan),
                        onPause: () => controller.pauseDownload(plan.id),
                        onResume: () => controller.resumeDownload(plan.id),
                        onCancel: () => controller.cancelDownload(plan.id),
                      ),
                    ),
                ],
                if (controller.completedPlans.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Recently Completed',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  for (final plan in controller.completedPlans)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: DownloadsTile(
                        plan: plan,
                        progress: 1.0,
                        localDeck: controller.localDeckForPlan(plan),
                        onDismiss: () => controller.dismissCompleted(plan.id),
                      ),
                    ),
                ],
              ],
            ),
    );
  }
}
