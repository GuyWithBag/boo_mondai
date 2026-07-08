// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/sync_page.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonColor,
        ChangeTrackerEntry,
        ChangeTrackerRouteArgs,
        ChangeTrackerStatus,
        ChangeTrackerSummaryChips,
        MutableEntity,
        StatusLayoutState,
        SyncController,
        Scaffold,
        buttonStyle;
import 'package:flutter/material.dart' hide Scaffold;
import 'package:go_router/go_router.dart';
import 'package:theme_variants/theme_variants.dart' show ThemeVariantsContext;

class SyncPage<T extends MutableEntity> extends StatelessWidget {
  const SyncPage({super.key, required this.syncController});

  final SyncController<T> syncController;

  ChangeTrackerEntry get entry => syncController.currentEntry!;

  void _viewChanges(BuildContext context) {
    final service = syncController.changeTrackerService;
    if (service == null) return;

    context.push(
      '/change-review/${service.id}/${entry.id}',
      extra: ChangeTrackerRouteArgs(entryId: entry.id, serviceId: service.id),
    );
  }

  void _apply() {
    syncController.applyCurrentEntry();
  }

  void _discard() {
    syncController.dismissCurrentEntry();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final progress = (entry.progress ?? 0).clamp(0.0, 1.0);

    final title = switch (entry.status) {
      ChangeTrackerStatus.idle => 'Sync',
      ChangeTrackerStatus.planning => 'Planning sync',
      ChangeTrackerStatus.fetching => 'Fetching sync data',
      ChangeTrackerStatus.reviewing => 'Review sync changes',
      ChangeTrackerStatus.paused => 'Sync paused',
      ChangeTrackerStatus.applying => 'Applying sync',
      ChangeTrackerStatus.completed => 'Sync complete',
      ChangeTrackerStatus.failed => 'Sync failed',
      ChangeTrackerStatus.canceled => 'Sync canceled',
      ChangeTrackerStatus.alreadyUpToDate => 'Everything is already up to date',
    };

    final message = switch (entry.status) {
      ChangeTrackerStatus.idle => 'Ready to sync.',
      ChangeTrackerStatus.planning => '${(progress * 100).round()}%',
      ChangeTrackerStatus.fetching => '${(progress * 100).round()}%',
      ChangeTrackerStatus.reviewing => 'Review changes before applying.',
      ChangeTrackerStatus.paused => 'Sync is paused.',
      ChangeTrackerStatus.applying => '${(progress * 100).round()}%',
      ChangeTrackerStatus.completed => 'Sync processed successfully.',
      ChangeTrackerStatus.failed => entry.errorMessage ?? 'Sync failed.',
      ChangeTrackerStatus.canceled => 'Sync was canceled.',
      ChangeTrackerStatus.alreadyUpToDate => 'No changes to apply.',
    };

    final progressValue = switch (entry.status) {
      ChangeTrackerStatus.planning ||
      ChangeTrackerStatus.fetching ||
      ChangeTrackerStatus.applying => progress,
      _ => null,
    };

    final canViewChanges =
        entry.status == ChangeTrackerStatus.reviewing ||
        entry.status == ChangeTrackerStatus.completed;
    final canApply = entry.status == ChangeTrackerStatus.reviewing;
    final icon = entry.status == ChangeTrackerStatus.alreadyUpToDate
        ? Icons.check_circle_outline_rounded
        : Icons.sync_rounded;
    final isDoneFetching = entry.status != ChangeTrackerStatus.fetching;
    return Scaffold(
      centeredBody: true,
      scrollable: false,
      body: StatusLayoutState(
        icon: icon,
        title: title,
        message: message,
        progressValue: progressValue,
        actions: [
          if (canApply)
            Expanded(
              child: Button(
                style: buttonStyle.resolve(tokens, const [ButtonColor.primary]),
                onPressed: _apply,
                child: const Text('APPLY'),
              ),
            ),
          if (canViewChanges)
            Expanded(
              child: Button(
                onPressed: () => _viewChanges(context),
                child: const Text('VIEW CHANGES'),
              ),
            ),
        ],
        extraAction: Button(
          onPressed: _discard,
          child: Text(canApply ? 'Discard' : 'Cancel'),
        ),
        child: isDoneFetching ? ChangeTrackerSummaryChips(entry: entry) : null,
      ),
    );
  }
}
