import 'package:boo_mondai/features/app_theme/button.variant.dart';
import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        BottomNavBar,
        Button,
        ChangeTrackerService,
        ChangeTrackerStatus,
        ChangeTrackerSummaryChips,
        ChangeType,
        ChangedEntityBlock,
        ChangedEntitySection,
        Deck,
        DeckTile,
        DeckTileState,
        Scaffold,
        ServiceRegistry,
        useChangeTrackerController,
        MetaLabel;
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

    void popToFirstRoute() {
      while (context.canPop()) {
        context.pop();
      }
    }

    if (entry == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        popToFirstRoute();
      });
      return Scaffold(
        backgroundColor: tokens.colorScaffoldBackground,
        inheritMainBottomNavBarHeight: false,

        body: Container(color: Colors.red),
      );
    }

    final canReviewChanges = entry.status == ChangeTrackerStatus.reviewing;

    return Scaffold(
      appBar: AppBar(
        title: 'Sync',
        subTitle: 'Review changes before applying',
        automaticallyImplyPopButton: false,
      ),
      inheritMainBottomNavBarHeight: false,
      bottomNavBar: BottomNavBar(
        preferredHeight: canReviewChanges ? 200 : 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: tokens.spaceLayoutGapSm,
          children: [
            if (canReviewChanges)
              Row(
                spacing: tokens.spaceLayoutGapSm,
                children: [
                  Expanded(
                    child: Button(
                      onPressed: () {
                        controller.cancel(entry.id);
                        popToFirstRoute();
                      },
                      child: const Text('Discard'),
                    ),
                  ),
                  Expanded(
                    child: Button(
                      style: buttonStyle.resolve(tokens, const [
                        ButtonColor.primary,
                      ]),
                      onPressed: () {
                        controller.apply(entry.id);
                        popToFirstRoute();
                      },
                      child: const Text('Looks Good'),
                    ),
                  ),
                ],
              ),
            Button(onPressed: popToFirstRoute, child: const Text('Back')),
          ],
        ),
      ),
      body: Column(
        spacing: tokens.spaceLayoutGapMd,
        children: [
          ChangeTrackerSummaryChips(entry: entry),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: entry.changes.length,
            separatorBuilder: (_, _) =>
                SizedBox(height: tokens.spaceLayoutGapMd.h),
            itemBuilder: (context, index) {
              final changedEntity = entry.changes[index];
              final entity = changedEntity.afterChange;
              final entityIsDeck = entity is Deck;

              if (changedEntity.changeType == ChangeType.added ||
                  changedEntity.changeType == ChangeType.removed) {
                return ChangedEntityBlock(
                  changedEntity: changedEntity,
                  name: entityIsDeck ? entity.title : null,
                  child: entityIsDeck
                      ? SizedBox(
                          height: 180.h,
                          child: Center(
                            child: DeckTile(
                              state: DeckTileState.spread,
                              deck: entity,
                              width: 100,
                            ),
                          ),
                        )
                      : null,
                );
              }
              if (entityIsDeck) {
                return ChangedEntitySection(
                  leading: DeckTile(
                    deck: entity,
                    width: 80.w,
                    state: DeckTileState.bare,
                  ),
                  metaLabels: [
                    MetaLabel(icon: Icons.build, label: entity.version),
                  ],
                  entity: entry.changes[index],
                );
              }
              return ChangedEntitySection(entity: entry.changes[index]);
            },
          ),
        ],
      ),
    );
  }
}
