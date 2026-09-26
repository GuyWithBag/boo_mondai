// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/view_deck_downloads_page.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        ChangeTrackerController,
        ChangeTrackerRouteArgs,
        DownloadsTile,
        Services,
        StatusLayoutState,
        ViewDeckDownloadsAppBar,
        Scaffold,
        ViewDeckDownloadsController;
import 'package:flutter/material.dart' hide Scaffold;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:signals/signals_flutter.dart';
import 'package:signals_hooks/signals_hooks.dart';

class ViewDeckDownloadsPage extends HookWidget {
  const ViewDeckDownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final changeTrackerPageArgs = useMemoized(
      () => signal(const ChangeTrackerRouteArgs.missing(entryId: '')),
    );
    final changeTrackerController = useMemoized(
      () => ChangeTrackerController(
        service: Services.deckDownloads.changeTrackerService,
        pageArgs: changeTrackerPageArgs,
      ),
      [changeTrackerPageArgs],
    );
    final controller = useMemoized(
      () => ViewDeckDownloadsController(
        changeTrackerController: changeTrackerController,
        downloadsService: Services.deckDownloads,
      ),
      [changeTrackerController],
    );
    useEffect(() {
      return () {
        controller.dispose();
        changeTrackerController.dispose();
        changeTrackerPageArgs.dispose();
      };
    }, [controller, changeTrackerController, changeTrackerPageArgs]);

    return Provider.value(
      value: controller,
      child: const _ViewDeckDownloadsView(),
    );
  }
}

class _ViewDeckDownloadsView extends SignalWidget {
  const _ViewDeckDownloadsView();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ViewDeckDownloadsController>();
    final activeEntries = controller.activeEntries.value;
    final completedPlans = controller.completedPlans.value;

    return Scaffold(
      appBar: const ViewDeckDownloadsAppBar(),
      body: controller.isEmpty.value
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
                if (activeEntries.isNotEmpty) ...[
                  for (final plan in activeEntries)
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
                if (completedPlans.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Recently Completed',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  for (final plan in completedPlans)
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
