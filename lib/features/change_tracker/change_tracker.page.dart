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
        DeckListing,
        DeckListingTile,
        DeckTile,
        DeckTileState,
        LocalDB,
        ModalAction,
        Scaffold,
        ServiceRegistry,
        showModal,
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

    Deck? deckForListing(DeckListing listing) {
      for (final change in entry.changes) {
        final after = change.afterChange;
        if (after is Deck && after.id == listing.deckId) {
          return after.copyWith(listing: listing);
        }

        final before = change.beforeChange;
        if (before is Deck && before.id == listing.deckId) {
          return before.copyWith(listing: listing);
        }
      }

      return LocalDB.deck
          .selectByPk({'id': listing.deckId}, includeDeleted: true)
          ?.copyWith(listing: listing);
    }

    Future<void> discardRemoteChanges() async {
      final confirmed = await showModal<bool>(
        context: context,
        title: 'Discard remote changes?',
        subtitle:
            'This keeps your local data and makes the remote account match it. Remote edits will be overwritten, and rows that only exist remotely will be deleted from the account.',
        leading: const Icon(Icons.warning_amber_rounded),
        actions: const [
          ModalAction<bool>(value: false, label: 'Cancel'),
          ModalAction<bool>(
            value: true,
            label: 'Discard remote',
            color: ButtonColor.error,
          ),
        ],
      );
      if (confirmed != true) return;

      await controller.discard(entry.id);
      if (context.mounted) {
        popToFirstRoute();
      }
    }

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
                      onPressed: discardRemoteChanges,
                      variants: const [ButtonColor.error],
                      child: const Text('Discard'),
                    ),
                  ),
                  Expanded(
                    child: Button(
                      variants: const [ButtonColor.primary],
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
              final entityIsDeckListing = entity is DeckListing;
              final deckListingDeck = entityIsDeckListing
                  ? deckForListing(entity)
                  : null;
              final directionLabel = controller.getDirectionLabel(
                changedEntity.direction,
              );

              if (changedEntity.changeType == ChangeType.added ||
                  changedEntity.changeType == ChangeType.removed) {
                return ChangedEntityBlock(
                  changedEntity: changedEntity,
                  directionLabel: directionLabel,
                  name: entityIsDeck ? entity.title : deckListingDeck?.title,
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
                      : deckListingDeck == null
                      ? null
                      : Center(child: DeckListingTile(deck: deckListingDeck)),
                );
              }
              if (deckListingDeck != null) {
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
                  entity: entry.changes[index],
                );
              }
              return ChangedEntitySection(
                entity: entry.changes[index],
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
