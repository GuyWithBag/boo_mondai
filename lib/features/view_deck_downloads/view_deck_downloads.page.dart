// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/view_deck_downloads_page.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        DownloadsTile,
        Services,
        StatusLayoutState,
        ViewDeckDownloadsAppBar,
        Scaffold,
        ViewDeckDownloadsController,
        useChangeTrackerController;
import 'package:flutter/material.dart' hide Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class ViewDeckDownloadsPage extends HookWidget {
  const ViewDeckDownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final changeTrackerController = useChangeTrackerController(
      service: Services.deckDownloads.changeTrackerService,
    );
    final controller = useMemoized(
      () => ViewDeckDownloadsController(
        changeTrackerController: changeTrackerController,
        downloadsService: Services.deckDownloads,
      ),
      [changeTrackerController],
    );
    useEffect(() => controller.dispose, [controller]);

    return ChangeNotifierProvider.value(
      value: controller,
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
      appBar: const ViewDeckDownloadsAppBar(),
      body: controller.isEmpty
          ? const Center(
              child: StatusLayoutState(
                icon: Icons.download_done_rounded,
                title: 'No downloads',
                message: 'Downloaded decks will appear here.',
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (controller.activeEntries.isNotEmpty) ...[
                  for (final plan in controller.activeEntries)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: DownloadsTile(
                        entry: plan,
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
                        entry: plan,
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
