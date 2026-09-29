import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonColor,
        ChipTone,
        DeckDetails,
        DeckFormValidator,
        Deck,
        DeckProfilesLabel,
        DeckTile,
        HeaderBadge,
        MetaLabel,
        DeckTileState,
        SurfacePadding,
        SurfaceShape,
        SurfaceColor,
        ViewDeckSingleSheetController,
        surfaceStyle,
        Scaffold,
        ViewDeckSingleBottomNavBar,
        BackgroundImageSurface,
        SurfaceBorder,
        SurfaceShadow,
        AppBar,
        DateHelper,
        FormField,
        DecksDirectoryPaths,
        ToolBar,
        ToolBarController,
        showBottomSheet;
import 'package:flutter/material.dart'
    hide AppBar, FormField, Scaffold, showBottomSheet;
import 'package:flutter_hooks/flutter_hooks.dart' show useEffect, useMemoized;
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart'
    show Surface, ThemeVariantsContext;

Future<void> showViewDeckSingleSheet(BuildContext context, Deck deck) {
  return showBottomSheet(
    context: context,
    builder: (_) => ViewDeckSingleSheet(deck: deck),
  );
}

class ViewDeckSingleSheet extends SignalHookWidget {
  const ViewDeckSingleSheet({super.key, required this.deck});

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    // final decksController = context.read<ViewDecksLocalController>();
    final controller = useMemoized(() {
      return ViewDeckSingleSheetController(
        initialDeck: deck,
        coverImage: signal(null),
      );
    });
    useEffect(() => controller.dispose, [controller]);
    final toolBarController = useMemoized(() => ToolBarController());
    useEffect(() => toolBarController.dispose, [toolBarController]);
    final activeDeck = controller.deck.value;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 1,
      minChildSize: 0.4,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return Surface(
          style: surfaceStyle
              .resolve(tokens, const [SurfacePadding.none, SurfaceColor.muted])
              .copyWith(clipBehavior: Clip.antiAlias),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            bottomNavBar: ViewDeckSingleBottomNavBar(deck: activeDeck),
            scrollable: true,
            shouldConstrainWidth: false,
            inheritMainBottomNavBarHeight: false,
            isFloatingAppBar: true,
            scrollController: scrollController,
            toolBar: activeDeck.isEditable
                ? ToolBar.withActions(
                    controller: toolBarController,
                    useAttachments: true,
                    createAttachmentPath: (file) =>
                        DecksDirectoryPaths.attachment(
                          deckTitle: activeDeck.title,
                          fileNameWithoutExtension: file.name,
                        ),
                  )
                : null,
            appBar: AppBar(
              transparentBackground: true,
              actions: [
                Button.icon(
                  tokens: tokens,
                  icon: Icons.list,
                  onPressed: () => controller.onCreateListingPressed(context),
                ),
                Button.icon(
                  tokens: tokens,
                  icon: Icons.folder_outlined,
                  onPressed: () => controller.showDeckPath(context),
                ),
                Button.icon(
                  tokens: tokens,
                  icon: Icons.edit,
                  onPressed: activeDeck.isEditable
                      ? () => context.push('/decks-local/${activeDeck.id}/edit')
                      : null,
                ),
                Button.icon(
                  tokens: tokens,
                  icon: Icons.delete_outline,
                  color: ButtonColor.error,
                  onPressed: () => controller.deleteDeck(context),
                ),
              ],
              bottom: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: tokens.spaceScaffoldPadding,
                ),
                child: Wrap(
                  alignment: WrapAlignment.end,
                  spacing: tokens.spaceLayoutGapSm,
                  runSpacing: tokens.spaceLayoutGapSm,
                  children: [
                    if (activeDeck.isPremade)
                      const HeaderBadge(label: 'Premade'),
                    if (!activeDeck.isEditable)
                      const Chip(label: Text('Locked')),
                  ],
                ),
              ),
            ),
            padding: EdgeInsets.zero,
            body: activeDeck.isEditable
                ? Form(child: _Body(controller: controller))
                : _Body(controller: controller),
          ),
        );
      },
    );
  }
}

class _Body extends SignalHookWidget {
  const _Body({required this.controller});

  final ViewDeckSingleSheetController controller;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    final deckWidth = 160.w;
    final headerHeight = 300.h;
    final deckHeight = deckWidth / tokens.studyCardAspectRatio;
    final deckFloatInset =
        deckHeight - (tokens.radiusSurfaceLg - tokens.spaceLayoutPadding);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: headerHeight + tokens.radiusSurfaceLg,
          child: BackgroundImageSurface(image: controller.coverImage.value),
        ),
        Column(
          children: [
            SizedBox(height: headerHeight - deckFloatInset),
            _BodySubSection(
              controller: controller,
              deckWidth: deckWidth,
              collapseDistance: headerHeight * 0.55,
              floatingHitInset: deckFloatInset,
            ),
          ],
        ),
      ],
    );
  }
}

class _BodySubSection extends SignalHookWidget {
  const _BodySubSection({
    required this.controller,
    required this.deckWidth,
    required this.collapseDistance,
    required this.floatingHitInset,
  });

  final ViewDeckSingleSheetController controller;
  final double deckWidth;
  final double collapseDistance;
  final double floatingHitInset;

  @override
  Widget build(BuildContext context) {
    final deck = controller.deck;
    final activeDeck = deck.value;
    final tags = controller.tagNames.value;
    final tokens = context.themeTokens<AppTokens>();

    return SizedBox(
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: EdgeInsets.only(top: floatingHitInset),
            child: Surface(
              style: surfaceStyle.resolve(tokens, const [
                SurfaceShape.topRounded,
                SurfaceColor.muted,
                SurfaceBorder.top,
                SurfaceShadow.none,
                SurfacePadding.scaffold,
              ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DeckProfilesLabel(
                        profileName: controller.profileName.value,
                      ),
                    ],
                  ),
                  DeckDetails(
                    title: controller.title.value,
                    shortDescription: controller.shortDescription.value,
                    longDescription: controller.longDescription.value,
                    onTitleChanged: controller.setTitle,
                    onShortDescriptionChanged: controller.setShortDescription,
                    onLongDescriptionChanged: controller.setLongDescription,
                    tags: tags,
                    onTagsChanged: controller.setTags,
                    areTagsEditable: controller.deck.value.isEditable,
                    isEditable: controller.deck.value.isEditable,
                    tagsPlaceholder: controller.deck.value.isEditable
                        ? 'Add tags'
                        : 'No tags yet',
                    tagsTone: ChipTone.ghost,
                    metaLabels: Wrap(
                      spacing: tokens.spaceLayoutGapMd,
                      runSpacing: tokens.spaceLayoutGapSm,
                      children: [
                        MetaLabel(
                          icon: Icons.visibility_outlined,
                          label: controller.visibilityLabel.value,
                        ),
                        MetaLabel(
                          icon: Icons.style_outlined,
                          label: '${activeDeck.cardTemplatesCount} cards',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: tokens.spaceLayoutPadding,
            top: 0,
            child: controller.deck.value.isEditable
                ? FormField<String?>(
                    value: controller.coverImagePath.value,
                    validator: DeckFormValidator.optionalImage,
                    builder: (_, _) => DeckTile(
                      deck: activeDeck,
                      width: deckWidth,
                      state: DeckTileState.bare,
                      isImageEditable: true,
                      onImagePicked: controller.onCoverImagePicked,
                    ),
                  )
                : DeckTile(
                    deck: activeDeck,
                    width: deckWidth,
                    state: DeckTileState.bare,
                  ),
          ),
          Positioned(
            right: tokens.spaceLayoutPadding,
            top:
                floatingHitInset -
                tokens.radiusSurfaceLg -
                tokens.spaceLayoutPadding,
            child: Column(
              spacing: tokens.spaceLayoutGapSm,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MetaLabel(
                  icon: Icons.new_releases_outlined,
                  label: 'v${activeDeck.version}+${activeDeck.buildNumber}',
                  tooltip: 'Deck version and build number',
                ),
                MetaLabel(
                  icon: Icons.calendar_today_outlined,
                  label: DateHelper.formatDateYyyyMmDd(activeDeck.createdAt),
                  tooltip:
                      'Created ${DateHelper.formatDateYyyyMmDd(activeDeck.createdAt)}',
                ),
                MetaLabel(
                  icon: Icons.update_outlined,
                  label: DateHelper.formatDateYyyyMmDd(activeDeck.updatedAt),
                  tooltip:
                      'Updated ${DateHelper.formatDateYyyyMmDd(activeDeck.updatedAt)}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
