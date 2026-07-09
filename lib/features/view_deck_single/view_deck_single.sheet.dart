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
        LocalImageResolverHelper,
        MetaLabel,
        DeckTileState,
        SurfacePadding,
        SurfaceShape,
        SurfaceColor,
        ViewDecksLocalController,
        ViewDeckSingleSheetController,
        chipStyle,
        surfaceStyle,
        useViewDeckSingleSheet,
        Scaffold,
        ViewDeckSingleBottomNavBar,
        BackgroundImageSurface,
        SurfaceBorder,
        SurfaceShadow,
        AppBar,
        ViewDeckSingleHelper,
        DateHelper,
        ImageHelper,
        FormField,
        showBottomSheet;
import 'package:flutter/material.dart'
    hide AppBar, FormField, Scaffold, showBottomSheet;
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget;
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:go_router/go_router.dart' show GoRouterHelper;
import 'package:provider/provider.dart' show ReadContext;
import 'package:theme_variants/theme_variants.dart'
    show Surface, ThemeVariantsContext;

Future<void> showViewDeckSingleSheet(BuildContext context, Deck deck) {
  return showBottomSheet(
    context: context,
    builder: (_) => ViewDeckSingleSheet(deck: deck),
  );
}

class ViewDeckSingleSheet extends HookWidget {
  const ViewDeckSingleSheet({super.key, required this.deck});

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final decksController = context.read<ViewDecksLocalController>();
    final sheet = useViewDeckSingleSheet(
      context: context,
      initialDeck: deck,
      controller: decksController,
    );
    final activeDeck = sheet.deck;
    final publishChipStyle = chipStyle.resolve(tokens, [
      activeDeck.isPublished ? ChipTone.filled : ChipTone.hard,
    ]);

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
            appBar: AppBar(
              transparentBackground: true,
              actions: [
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
                  onPressed: sheet.deleteDeck,
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
                    ChipTheme(
                      data: publishChipStyle,
                      child: ChoiceChip(
                        avatar: Icon(
                          activeDeck.isPublished
                              ? Icons.public_outlined
                              : Icons.public_off_outlined,
                        ),
                        label: Text(
                          activeDeck.isPublished ? 'Published' : 'Draft',
                        ),
                        selected: activeDeck.isPublished,
                        onSelected: sheet.isSavingPublishState
                            ? null
                            : sheet.setPublished,
                      ),
                    ),
                    if (!activeDeck.isEditable)
                      const Chip(label: Text('Locked')),
                  ],
                ),
              ),
            ),
            padding: EdgeInsets.zero,
            body: activeDeck.isEditable
                ? Form(child: _Body(sheet: sheet))
                : _Body(sheet: sheet),
          ),
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.sheet});

  final ViewDeckSingleSheetController sheet;

  @override
  Widget build(BuildContext context) {
    final deck = sheet.deck;
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
          child: BackgroundImageSurface(
            image: ImageHelper.getImageProviderFromSource(
              LocalImageResolverHelper.resolveDeckCover(deck),
            ),
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: headerHeight - deckFloatInset),
              _BodySubSection(
                sheet: sheet,
                deckWidth: deckWidth,
                collapseDistance: headerHeight * 0.55,
                floatingHitInset: deckFloatInset,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BodySubSection extends StatelessWidget {
  const _BodySubSection({
    required this.sheet,
    required this.deckWidth,
    required this.collapseDistance,
    required this.floatingHitInset,
  });

  final ViewDeckSingleSheetController sheet;
  final double deckWidth;
  final double collapseDistance;
  final double floatingHitInset;

  @override
  Widget build(BuildContext context) {
    final deck = sheet.deck;
    final tags = deck.tags.map((tag) => tag.name).toList(growable: false);
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
                        profileName: ViewDeckSingleHelper.profileName(deck),
                        profileAvatarUrl: ViewDeckSingleHelper.profileAvatarUrl(
                          deck,
                        ),
                        sourceProfileName:
                            ViewDeckSingleHelper.sourceProfileName(deck),
                        sourceProfileAvatarUrl:
                            ViewDeckSingleHelper.sourceProfileAvatarUrl(deck),
                      ),
                    ],
                  ),
                  DeckDetails(
                    title: ViewDeckSingleHelper.title(deck),
                    shortDescription: ViewDeckSingleHelper.shortDescription(
                      deck,
                    ),
                    longDescription: ViewDeckSingleHelper.longDescription(deck),
                    onTitleChanged: sheet.updateTitle,
                    onShortDescriptionChanged: sheet.updateShortDescription,
                    onLongDescriptionChanged: sheet.updateLongDescription,
                    tags: tags,
                    onTagsChanged: sheet.updateTags,
                    areTagsEditable: deck.isEditable,
                    isEditable: deck.isEditable,
                    tagsPlaceholder: deck.isEditable
                        ? 'Add tags'
                        : 'No tags yet',
                    tagsTone: ChipTone.ghost,
                    metaLabels: Wrap(
                      spacing: tokens.spaceLayoutGapMd,
                      runSpacing: tokens.spaceLayoutGapSm,
                      children: [
                        MetaLabel(
                          icon: Icons.visibility_outlined,
                          label: ViewDeckSingleHelper.visibilityLabel(deck),
                        ),
                        MetaLabel(
                          icon: Icons.style_outlined,
                          label: '${deck.cardCount} cards',
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
            child: deck.isEditable
                ? FormField<String?>(
                    value: LocalImageResolverHelper.resolveDeckCover(deck),
                    listenable: sheet,
                    valueReader: () {
                      return LocalImageResolverHelper.resolveDeckCover(
                        sheet.deck,
                      );
                    },
                    validator: DeckFormValidator.optionalImage,
                    builder: (_, _) => DeckTile(
                      deck: deck,
                      width: deckWidth,
                      state: DeckTileState.bare,
                      isImageEditable: true,
                      onImagePicked: sheet.updateCoverImage,
                    ),
                  )
                : DeckTile(
                    deck: deck,
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
                  label: 'v${deck.version}+${deck.buildNumber}',
                  tooltip: 'Deck version and build number',
                ),
                MetaLabel(
                  icon: Icons.calendar_today_outlined,
                  label: DateHelper.formatDateYyyyMmDd(deck.createdAt),
                  tooltip:
                      'Created ${DateHelper.formatDateYyyyMmDd(deck.createdAt)}',
                ),
                MetaLabel(
                  icon: Icons.update_outlined,
                  label: DateHelper.formatDateYyyyMmDd(deck.updatedAt),
                  tooltip:
                      'Updated ${DateHelper.formatDateYyyyMmDd(deck.updatedAt)}',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
