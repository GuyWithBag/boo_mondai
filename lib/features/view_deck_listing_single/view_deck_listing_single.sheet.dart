import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        Button,
        ButtonColor,
        ChangeTrackerController,
        DateHelper,
        Deck,
        DeckDetails,
        DeckListingSheetMode,
        DeckProfilesLabel,
        DeckTile,
        DeckTileState,
        ErrorState,
        MetaLabel,
        Scaffold,
        SurfaceColor,
        SurfacePadding,
        SurfaceShape,
        ViewDeckListingSingleController,
        ViewDeckListingsController,
        showBottomSheet,
        surfaceStyle,
        useViewDeckListingSingleController,
        ViewDeckSingleHelper,
        ChipTone,
        SurfaceBorder,
        SurfaceShadow,
        DiscussionSection;
import 'package:flutter/material.dart'
    show
        BuildContext,
        Widget,
        StatelessWidget,
        ScrollController,
        VoidCallback,
        Center,
        SizedBox,
        Text,
        WidgetsBinding,
        ScaffoldMessenger,
        SnackBar,
        DraggableScrollableSheet,
        CrossAxisAlignment,
        EdgeInsets,
        Icons,
        Row,
        Column,
        SliverToBoxAdapter,
        CustomScrollView,
        Positioned,
        Stack,
        Colors,
        CarouselView,
        MainAxisAlignment,
        Clip,
        Axis;
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget, useEffect;

import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, ReadContext;
import 'package:theme_variants/theme_variants.dart'
    show ThemeVariantsContext, Surface;

Future<void> showViewDeckListingSingleSheet(
  BuildContext context,
  Deck deck, {
  DeckListingSheetMode initialMode = DeckListingSheetMode.preview,
}) {
  return showBottomSheet(
    context: context,
    builder: (_) {
      final controller = ViewDeckListingsController()..decks = [deck];
      return ChangeNotifierProvider<ViewDeckListingsController>.value(
        value: controller,
        child: ViewDeckListingSingleSheet(deck: deck, initialMode: initialMode),
      );
    },
  );
}

class ViewDeckListingSingleSheet extends HookWidget {
  const ViewDeckListingSingleSheet({
    super.key,
    required this.deck,
    this.initialMode = DeckListingSheetMode.preview,
  });

  final Deck deck;
  final DeckListingSheetMode initialMode;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final controller = context.read<ViewDeckListingsController>();
    final changeReviewController = context.read<ChangeTrackerController>();
    final sheet = useViewDeckListingSingleController(
      deckId: deck.id,
      initialDeck: deck,
      initialMode: initialMode,
      controller: controller,
      changeReviewController: changeReviewController,
    );
    final sheetDeck = sheet.deck;

    useEffect(() {
      final error = sheet.error;
      if (error == null) return null;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', '')),
          ),
        );
        sheet.clearErrors();
      });
      return null;
    }, [sheet.error]);

    if (sheetDeck == null) {
      return ErrorState(
        exception: Exception('Online deck not found.'),
        onRetry: () => context.pop(),
      );
    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 1,
      minChildSize: 0.4,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return Surface(
          style: surfaceStyle
              .resolve(tokens, const [SurfacePadding.none])
              .copyWith(clipBehavior: Clip.antiAlias),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            scrollable: false,
            center: false,
            constrainWidth: false,
            padding: EdgeInsets.zero,
            body: _Body(
              initialMode: initialMode,
              scrollController: scrollController,
              controller: sheet,
              onBackPressed: () {
                if (context.canPop()) {
                  context.pop();
                  return;
                }
                context.go('/');
              },
            ),
          ),
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.scrollController,
    required this.controller,
    required this.onBackPressed,
    required this.initialMode,
  });

  final ScrollController scrollController;
  final ViewDeckListingSingleController controller;
  final VoidCallback onBackPressed;
  final DeckListingSheetMode initialMode;

  @override
  Widget build(BuildContext context) {
    final deck = controller.deck!;
    final tokens = context.themeTokens<AppTokens>();
    final headerHeight = 350.h.clamp(300.0, 390.0).toDouble();
    final tags = deck.tags.map((tag) => tag.name).toList(growable: false);
    final isEditing = initialMode == DeckListingSheetMode.editor;

    return Stack(
      children: [
        CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                spacing: tokens.spaceLayoutGapMd,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: headerHeight,
                    child: CarouselView.weighted(
                      scrollDirection: Axis.horizontal,
                      flexWeights: const <int>[1],
                      children: List<Widget>.generate(10, (int index) {
                        return Center(child: Text('Item $index'));
                      }),
                    ),
                  ),
                  Surface(
                    style: surfaceStyle.resolve(tokens, const [
                      SurfaceShape.topRounded,
                      SurfaceColor.muted,
                      SurfaceBorder.top,
                      SurfaceShadow.none,
                      SurfacePadding.scaffold,
                    ]),
                    child: Column(
                      spacing: tokens.spaceLayoutGapMd,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          spacing: tokens.spaceLayoutGapSm,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DeckProfilesLabel(
                              profileName: deck.userProfile!.username,
                              profileAvatarUrl: deck.userProfile!.avatarUrl,
                              sourceProfileAvatarUrl:
                                  ViewDeckSingleHelper.sourceProfileAvatarUrl(
                                    deck,
                                  ),
                              sourceProfileName:
                                  ViewDeckSingleHelper.sourceProfileName(deck),
                            ),
                            Row(
                              spacing: tokens.spaceLayoutGapSm,
                              children: [
                                Button.icon(icon: Icons.arrow_upward),
                                Button.icon(icon: Icons.arrow_downward),
                                Button.icon(icon: Icons.monitor_heart),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            MetaLabel(label: '', icon: Icons.download),
                            MetaLabel(label: '', icon: Icons.arrow_upward),
                            MetaLabel(label: '', icon: Icons.arrow_downward),
                            MetaLabel(label: '', icon: Icons.favorite),
                          ],
                        ),
                        Center(
                          child: DeckTile(
                            deck: deck,
                            state: DeckTileState.spread,
                            width: 190,
                          ),
                        ),
                        DeckDetails(
                          title: ViewDeckSingleHelper.title(deck),
                          shortDescription:
                              ViewDeckSingleHelper.shortDescription(deck),
                          longDescription: ViewDeckSingleHelper.longDescription(
                            deck,
                          ),
                          isEditable: isEditing,
                          tags: tags,
                          areTagsEditable: deck.isEditable,
                          tagsPlaceholder: deck.isEditable
                              ? 'Add tags'
                              : 'No tags yet',
                          tagsTone: ChipTone.ghost,
                          onTitleChanged: controller.updateTitle,
                          onShortDescriptionChanged:
                              controller.updateShortDescription,
                          onLongDescriptionChanged:
                              controller.updateLongDescription,
                          metaLabels: Column(
                            spacing: tokens.spaceLayoutGapSm,
                            children: [
                              Row(
                                spacing: tokens.spaceLayoutGapSm,
                                children: [
                                  MetaLabel(
                                    icon: Icons.new_releases_outlined,
                                    label:
                                        'v${deck.version}+${deck.buildNumber}',
                                    tooltip: 'Deck version and build number',
                                  ),
                                  MetaLabel(
                                    icon: Icons.style_outlined,
                                    label: '${deck.cardCount} cards',
                                  ),
                                ],
                              ),
                              Row(
                                spacing: tokens.spaceLayoutGapSm,
                                children: [
                                  MetaLabel(
                                    icon: Icons.calendar_today_outlined,
                                    label: DateHelper.formatDateYyyyMmDd(
                                      deck.createdAt,
                                    ),
                                    tooltip:
                                        'Created ${DateHelper.formatDateYyyyMmDd(deck.createdAt)}',
                                  ),
                                  MetaLabel(
                                    icon: Icons.update_outlined,
                                    label: DateHelper.formatDateYyyyMmDd(
                                      deck.updatedAt,
                                    ),
                                    tooltip:
                                        'Updated ${DateHelper.formatDateYyyyMmDd(deck.updatedAt)}',
                                  ),
                                  MetaLabel(
                                    icon: Icons.update_outlined,
                                    label: DateHelper.formatDateYyyyMmDd(
                                      deck.updatedAt,
                                    ),
                                    tooltip:
                                        'Published ${DateHelper.formatDateYyyyMmDd(deck.updatedAt)}',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // SectionEyebrow('Featured Cards'),
                        if (deck.isPublished) ...[
                          DiscussionSection(sheet: controller),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: tokens.spaceLayoutPadding,
          left: 0,
          right: 0,
          child: AppBar(
            transparentBackground: true,
            onPop: onBackPressed,
            actions: [
              if (controller.canPublish) ...[
                Button.icon(
                  icon: Icons.public_outlined,
                  color: ButtonColor.success,
                  onPressed: controller.publishDraft,
                ),
              ],
              Button.icon(
                icon: controller.isDownloading
                    ? Icons.sync
                    : Icons.cloud_download_outlined,
                color: ButtonColor.success,
                onPressed:
                    controller.isDownloading ||
                        controller.onDownloadPressed == null
                    ? null
                    : controller.onDownloadPressed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
