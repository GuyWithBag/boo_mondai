import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        BottomNavBar,
        Button,
        ChangeTrackerSummaryChips,
        ChangeType,
        ChangedEntityBlock,
        ChangedEntitySection,
        Deck,
        DeckListing,
        DeckListingTile,
        DeckTile,
        DeckTileState,
        Scaffold,
        ServiceRegistry,
        MetaLabel,
        ButtonColor,
        ChangeTrackerController;
import 'package:flutter/material.dart' hide Scaffold, AppBar;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  const ChangeTrackerPage({super.key, required this.controller});

  /// Route data containing the entry id and feature-owned tracker service.
  final ChangeTrackerController controller;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    // final service = args.serviceId == null
    //     ? null
    //     : ServiceRegistry.maybeById<ChangeTrackerService>(args.serviceId!);
    // final controller = useMemoized(
    //   () => ChangeTrackerController(service: service),
    // );
    final entry = controller.entry;

    if (entry.value == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.popToFirstRoute(context);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: 'Sync',
        subTitle: 'Review changes before applying',
        automaticallyImplyPopButton: false,
      ),
      inheritMainBottomNavBarHeight: false,
      bottomNavBar: BottomNavBar(
        preferredHeight: controller.isReviewing.value ? 200 : 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: tokens.spaceLayoutGapSm,
          children: [
            if (controller.isReviewing.value)
              Row(
                spacing: tokens.spaceLayoutGapSm,
                children: [
                  Expanded(
                    child: Button(
                      onPressed: () =>
                          controller.onDiscardRemoteChanges(context),
                      variants: const [ButtonColor.error],
                      child: const Text('Discard'),
                    ),
                  ),
                  Expanded(
                    child: Button(
                      variants: const [ButtonColor.primary],
                      onPressed: () {
                        controller.apply(entry.value!.id);
                        controller.popToFirstRoute(context);
                      },
                      child: const Text('Looks Good'),
                    ),
                  ),
                ],
              ),
            Button(
              onPressed: () => controller.popToFirstRoute(context),
              child: const Text('Back'),
            ),
          ],
        ),
      ),
      body: Column(
        spacing: tokens.spaceLayoutGapMd,
        children: [
          ChangeTrackerSummaryChips(entry: entry.value!),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: entry.value!.changes.length,
            separatorBuilder: (_, _) =>
                SizedBox(height: tokens.spaceLayoutGapMd.h),
            itemBuilder: (context, index) {
              final changedEntity = entry.value!.changes[index];
              final entity = changedEntity.afterChange;
              final entityIsDeck = entity is Deck;
              final entityIsDeckListing = entity is DeckListing;
              final directionLabel = controller.getDirectionLabel(
                changedEntity.direction,
              );

              if (changedEntity.changeType == ChangeType.added ||
                  changedEntity.changeType == ChangeType.removed) {
                return ChangedEntityBlock(
                  changedEntity: changedEntity,
                  directionLabel: directionLabel,
                  name: entityIsDeck ? entity.title : '',
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
                      : !entityIsDeckListing
                      ? null
                      : Center(
                          // child: DeckListingTile(
                          //   controller: DeckListingTileController(
                          //     deck: ,
                          //     content: ,
                          //     listing: ,
                          //     profile: ,
                          //     sourceProfile:
                          //   ),
                          // )
                        ),
                );
              }
              if (entityIsDeckListing) {
                return ChangedEntitySection(
                  // leading: Expanded(
                  //   child: Transform.scale(
                  //     scale: 0.2,
                  //     child: DeckListingTile(deck: deckListingDeck),
                  //   ),
                  // ),
                  metaLabels: [
                    MetaLabel(icon: Icons.sync_alt, label: directionLabel),
                  ],
                  entity: changedEntity,
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
                    MetaLabel(icon: Icons.sync_alt, label: directionLabel),
                    MetaLabel(icon: Icons.build, label: entity.version),
                  ],
                  entity: entry.value!.changes[index],
                );
              }
              return ChangedEntitySection(
                entity: entry.value!.changes[index],
                metaLabels: [
                  MetaLabel(icon: Icons.sync_alt, label: directionLabel),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
