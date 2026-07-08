import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        BottomNavBar,
        ChangedEntitySection,
        ChangeTrackerService,
        ChangeTrackerSummaryChips,
        Scaffold,
        ServiceRegistry,
        useChangeTrackerController,
        Button;
import 'package:flutter/material.dart' hide Scaffold, AppBar;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:theme_variants/theme_variants.dart';

/// Route data required to review a tracked change entry.
///
/// The entry id and service id stay in the URL so the page can recover the
/// tracker from [ServiceRegistry] when go_router `extra` is unavailable.
class ChangeTrackerRouteArgs {
  /// Creates route data for a real change tracker entry.
  const ChangeTrackerRouteArgs({
    required this.entryId,
    required this.serviceId,
  });

  const ChangeTrackerRouteArgs.missing({required this.entryId, this.serviceId});

  /// Id of the entry managed by the registered service.
  final String entryId;

  /// Id of the registered tracker service that stores the live entry.
  final String? serviceId;
}

/// Full-page UI for reviewing a pending tracked change entry.
///
/// The route receives [ChangeTrackerRouteArgs] through go_router `extra` or
/// path parameters, then resolves the live entry from [ServiceRegistry] so
/// status and change records stay current while the user reviews the plan.
class ChangeTrackerPage extends HookWidget {
  /// Creates a page that resolves and displays the route entry.
  const ChangeTrackerPage({super.key, required this.args});

  /// Route data containing the entry id and feature-owned tracker service.
  final ChangeTrackerRouteArgs args;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final service = args.serviceId == null
        ? null
        : ServiceRegistry.maybeById<ChangeTrackerService>(args.serviceId!);
    final controller = useChangeTrackerController(service: service);
    final entry = controller.entryById(args.entryId);

    if (entry == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.canPop()) context.pop();
      });
      return Scaffold(
        backgroundColor: tokens.colorScaffoldBackground,
        body: Container(color: Colors.red),
      );
    }

    return Scaffold(
      appBar: AppBar(title: 'Sync', automaticallyImplyPopButton: false),
      bottomNavBar: BottomNavBar(
        preferredHeight: 130,
        child: Column(
          spacing: tokens.spaceLayoutGapMd,
          children: [
            Row(
              spacing: tokens.spaceLayoutGapSm,
              children: [
                Button(
                  onPressed: () {
                    controller.cancel(entry.id);
                    context.pop();
                  },
                  child: const Text('Discard'),
                ),
                Button(
                  onPressed: () {
                    controller.apply(entry.id);
                    context.pop();
                  },
                  child: const Text('Looks Good'),
                ),
              ],
            ),
            Button(onPressed: () => context.pop(), child: const Text('Back')),
          ],
        ),
      ),
      body: Column(
        spacing: tokens.spaceLayoutGapMd,
        children: [
          Column(
            spacing: tokens.spaceLayoutGapMd,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Review changes before applying'),
              ChangeTrackerSummaryChips(entry: entry),
            ],
          ),
          ListView.separated(
            itemCount: entry.changes.length,
            separatorBuilder: (_, _) =>
                SizedBox(height: tokens.spaceLayoutGapMd.h),
            itemBuilder: (context, index) {
              return ChangedEntitySection(entity: entry.changes[index]);
            },
          ),
        ],
      ),
    );
  }
}
