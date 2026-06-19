// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// PATH: lib/pages/view_deck.local.page.dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

import 'package:boo_mondai/lib.barrel.dart'
    show
        AppTokens,
        Button,
        ButtonColor,
        ChipTone,
        DeckDetails,
        Deck,
        DeckProfilesLabel,
        DeckTile,
        HeaderBadge,
        MetaLabel,
        DeckTileState,
        SurfacePadding,
        SurfaceShape,
        SurfaceColor,
        TextSize,
        TextWeight,
        ViewDecksLocalController,
        ViewDeckSingleSheetController,
        chipStyle,
        textStyle,
        surfaceStyle,
        useViewDeckSingleSheet,
        Scaffold,
        CollapsingHeaderItem,
        ViewDeckSingleBottomNavbar,
        BackgroundImageSurface,
        SurfaceBorder,
        SurfaceShadow,
        AppBar,
        EditableTextValue,
        ViewDeckSingleHelper,
        DateHelper,
        ImageHelper,
        showBottomSheet;
import 'package:flutter/material.dart'
    show
        BuildContext,
        Widget,
        StatelessWidget,
        ScrollController,
        VoidCallback,
        Chip,
        Colors,
        Clip,
        EdgeInsets,
        DraggableScrollableSheet,
        Positioned,
        SizedBox,
        Column,
        Stack,
        SliverToBoxAdapter,
        CustomScrollView,
        Alignment,
        Icons,
        WrapAlignment,
        Icon,
        Text,
        ChoiceChip,
        ChipTheme,
        Wrap,
        CrossAxisAlignment,
        MainAxisAlignment,
        Row,
        Padding;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:theme_variants/theme_variants.dart';

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
    final sheetDeck = sheet.deck;

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
            bottomNavigationBar: ViewDeckSingleBottomNavbar(deck: sheetDeck),
            scrollable: false,
            center: false,
            constrainWidth: false,
            padding: EdgeInsets.zero,
            body: _Body(
              scrollController: scrollController,
              controller: sheet,
              onBackPressed: () {
                if (context.canPop()) {
                  context.pop();
                  return;
                }
                context.go('/');
              },
              onEditPressed: sheetDeck.isEditable
                  ? () => context.push('/decks-local/${sheetDeck.id}/edit')
                  : null,
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
    required this.onEditPressed,
  });

  final ScrollController scrollController;
  final ViewDeckSingleSheetController controller;
  final VoidCallback onBackPressed;
  final VoidCallback? onEditPressed;

  @override
  Widget build(BuildContext context) {
    final deck = controller.deck;
    final tokens = context.themeTokens<AppTokens>();
    final publishChipStyle = chipStyle.resolve(tokens, [
      deck.isPublished ? ChipTone.filled : ChipTone.hard,
    ]);

    final deckWidth = 160.w;
    final headerHeight = 350.h.clamp(300.0, 390.0).toDouble();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    height: headerHeight + tokens.radiusSurfaceLg,
                    child: BackgroundImageSurface(
                      image: ImageHelper.providerFromSource(deck.coverImageUrl),
                      onImagePicked: deck.isEditable
                          ? controller.onCoverImagePicked
                          : null,
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: headerHeight),
                      _BodySubSection(
                        controller: controller,
                        deckWidth: deckWidth,
                        scrollController: scrollController,
                        collapseDistance: headerHeight * 0.55,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: AppBar(
            transparentBackground: true,
            onPop: onBackPressed,
            collapsible: true,
            scrollController: scrollController,
            collapseDistance: headerHeight * 0.55,
            actions: [
              Button.icon(icon: Icons.edit, onPressed: onEditPressed),
              Button.icon(
                icon: Icons.delete_outline,
                color: ButtonColor.error,
                onPressed: controller.onDeletePressed,
              ),
            ],
            bottom: Wrap(
              alignment: WrapAlignment.end,
              spacing: tokens.spaceLayoutGapSm,
              runSpacing: tokens.spaceLayoutGapSm,
              children: [
                if (deck.isPremade) const HeaderBadge(label: 'Premade'),
                ChipTheme(
                  data: publishChipStyle,
                  child: ChoiceChip(
                    avatar: Icon(
                      deck.isPublished
                          ? Icons.public_outlined
                          : Icons.public_off_outlined,
                    ),
                    label: Text(deck.isPublished ? 'Published' : 'Draft'),
                    selected: deck.isPublished,
                    onSelected: controller.isSavingPublishState
                        ? null
                        : controller.onPublishedChanged,
                  ),
                ),
                if (!deck.isEditable) const Chip(label: Text('Locked')),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BodySubSection extends StatelessWidget {
  const _BodySubSection({
    required this.controller,
    required this.deckWidth,
    required this.scrollController,
    required this.collapseDistance,
  });

  final ViewDeckSingleSheetController controller;
  final double deckWidth;
  final ScrollController scrollController;
  final double collapseDistance;

  @override
  Widget build(BuildContext context) {
    final deck = controller.deck;
    final tags = deck.tags.map((tag) => tag.name).toList(growable: false);
    final tokens = context.themeTokens<AppTokens>();
    return SizedBox(
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Surface(
            style: surfaceStyle.resolve(tokens, const [
              SurfaceShape.topRounded,
              SurfaceColor.muted,
              SurfaceBorder.top,
              SurfaceShadow.none,
              SurfacePadding.none,
            ]),
            child: Padding(
              padding: EdgeInsets.all(tokens.spaceScaffoldPadding),
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
                    title: EditableTextValue(
                      value: ViewDeckSingleHelper.title(deck),
                      editingValue: deck.title,
                      enabled: deck.isEditable,
                      placeholder: 'Deck title',
                      onSave: controller.onTitleChanged,
                      textStyle: textStyle.resolve(tokens, const [
                        TextSize.header,
                        TextWeight.heavy,
                      ]),
                    ),
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
                    shortDescription: EditableTextValue(
                      value: ViewDeckSingleHelper.shortDescription(deck),
                      editingValue: deck.shortDescription,
                      enabled: deck.isEditable,
                      placeholder: 'Short description',
                      isMarkdown: true,
                      onSave: controller.onShortDescriptionChanged,
                      textStyle: textStyle.resolve(tokens, const [
                        TextSize.labelSmall,
                        TextWeight.body,
                      ]),
                    ),
                    longDescription: EditableTextValue(
                      value: ViewDeckSingleHelper.longDescription(deck),
                      editingValue: deck.longDescription,
                      enabled: deck.isEditable,
                      placeholder: 'Long description',
                      maxLines: null,
                      isMarkdown: true,
                      onSave: controller.onLongDescriptionChanged,
                      textStyle: textStyle.resolve(tokens, const [
                        TextSize.bodyLarge,
                        TextWeight.body,
                      ]),
                    ),
                    tags: tags,
                    onTagsChanged: controller.onTagsChanged,
                    tagsEnabled: deck.isEditable,
                    tagsPlaceholder: deck.isEditable
                        ? 'Add tags'
                        : 'No tags yet',
                    tagsTone: ChipTone.ghost,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: tokens.spaceLayoutPadding,
            top:
                -(deckWidth / tokens.studyCardAspectRatio) +
                (tokens.radiusSurfaceLg - tokens.spaceLayoutPadding),
            child: CollapsingHeaderItem(
              scrollController: scrollController,
              collapseDistance: collapseDistance,
              alignment: Alignment.bottomLeft,
              child: DeckTile(
                deck: deck,
                width: deckWidth,
                state: DeckTileState.bare,
                isImageEditable: deck.isEditable,
                onImagePicked: controller.onCoverImagePicked,
              ),
            ),
          ),
          Positioned(
            right: tokens.spaceLayoutPadding,
            top: -tokens.radiusSurfaceLg - tokens.spaceLayoutPadding,
            child: CollapsingHeaderItem(
              scrollController: scrollController,
              collapseDistance: collapseDistance,
              alignment: Alignment.bottomLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MetaLabel(
                    icon: Icons.new_releases_outlined,
                    label: 'v${deck.version}+${deck.buildNumber}',
                    tooltip: 'Deck version and build number',
                  ),
                  SizedBox(height: tokens.spaceLayoutGapSm),
                  MetaLabel(
                    icon: Icons.calendar_today_outlined,
                    label: DateHelper.yyyyMmDd(deck.createdAt),
                    tooltip: 'Created ${DateHelper.yyyyMmDd(deck.createdAt)}',
                  ),
                  SizedBox(height: tokens.spaceLayoutGapSm),
                  MetaLabel(
                    icon: Icons.update_outlined,
                    label: DateHelper.yyyyMmDd(deck.updatedAt),
                    tooltip: 'Updated ${DateHelper.yyyyMmDd(deck.updatedAt)}',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
