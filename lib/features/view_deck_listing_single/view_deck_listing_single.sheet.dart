import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        Button,
        ButtonColor,
        CardTemplate,
        ChipTone,
        DateHelper,
        Deck,
        DeckDetails,
        DeckFormValidator,
        DeckListingSheetState,
        DeckProfilesLabel,
        DeckTile,
        DeckTileState,
        DiscussionSection,
        EditableCarousel,
        EditableFeaturedCardsColumn,
        FormField,
        MarkdownHelper,
        MetaLabel,
        NumberHelper,
        Scaffold,
        SectionEyebrow,
        Side,
        StoredMediaHelper,
        StoredMediaService,
        SurfaceBorder,
        SurfaceColor,
        SurfacePadding,
        SurfaceShadow,
        SurfaceShape,
        ToolBar,
        ViewCardsTile,
        ViewDeckListingSingleController,
        ViewDeckListingsController,
        ViewDeckSingleHelper,
        ViewPaddingSizedBox,
        showBottomSheet,
        showModal,
        showSnackbar,
        surfaceStyle,
        useToolBarController,
        useViewDeckListingSingleController,
        uuid;
import 'package:flutter/material.dart'
    hide FormField, Scaffold, AppBar, showBottomSheet;
import 'package:flutter_hooks/flutter_hooks.dart'
    show HookWidget, useEffect, useMemoized;

import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, ReadContext;
import 'package:theme_variants/theme_variants.dart'
    show ThemeVariantsContext, Surface;

Future<void> showViewDeckListingSingleSheet(
  BuildContext context,
  Deck deck, {
  DeckListingSheetState initialState = DeckListingSheetState.preview,
}) {
  return showBottomSheet(
    context: context,
    builder: (_) {
      final controller = ViewDeckListingsController()..decks = [deck];
      return ChangeNotifierProvider<ViewDeckListingsController>.value(
        value: controller,
        child: ViewDeckListingSingleSheet(
          deck: deck,
          initialState: initialState,
        ),
      );
    },
  );
}

class ViewDeckListingSingleSheet extends HookWidget {
  const ViewDeckListingSingleSheet({
    super.key,
    required this.deck,
    this.initialState = DeckListingSheetState.preview,
  });

  final Deck deck;
  final DeckListingSheetState initialState;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final controller = context.read<ViewDeckListingsController>();
    final sheet = useViewDeckListingSingleController(
      deckId: deck.id,
      initialDeck: deck,
      initialState: initialState,
      controller: controller,
    );
    final isEditing = sheet.state == DeckListingSheetState.editor;
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final toolBarController = useToolBarController();

    Future<void> addMarkdownAttachment() async {
      final file = await StoredMediaService.pickSupportedFile();
      if (file == null) return;

      final attachment = await MarkdownHelper.toPickedFileMediaMarkdownFormat(
        id: StoredMediaHelper.getSemanticId(
          'deck_listing',
          sheet.deck.id,
          'long_description',
          uuid.v7(),
        ),
        file: file,
      );
      if (attachment == null) return;

      toolBarController.insertMarkdown(attachment);
    }

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

    List<Widget> getAppBarActions() {
      final children = <Widget>[];
      if (isEditing) {
        if (sheet.deck.isPublished) {
          children.add(
            Button.icon(
              icon: Icons.public_off_outlined,
              color: ButtonColor.error,
              tokens: tokens,
              onPressed: sheet.canUnpublish ? sheet.unpublishDraft : null,
            ),
          );
        } else {
          children.add(
            Button.icon(
              icon: Icons.public_outlined,
              color: ButtonColor.success,
              tokens: tokens,
              onPressed: sheet.canPublish
                  ? () async {
                      if (!(formKey.currentState?.validate() ?? false)) return;
                      await sheet.publishDraft();
                    }
                  : null,
            ),
          );
        }
      } else {
        children.add(
          Button.icon(
            icon: sheet.isDownloading
                ? Icons.sync
                : Icons.cloud_download_outlined,
            color: ButtonColor.primary,
            tokens: tokens,
            onPressed: sheet.isDownloading || sheet.onDownloadPressed == null
                ? null
                : sheet.onDownloadPressed,
          ),
        );
      }
      return children;
    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 1,
      minChildSize: 0.4,
      maxChildSize: 1,
      builder: (context, scrollController) {
        final appBar = AppBar(
          transparentBackground: true,
          actions: getAppBarActions(),
          preferredHeight: 80,
        );
        final appBarHeight =
            appBar.preferredSize.height + MediaQuery.viewPaddingOf(context).top;

        return Surface(
          style: surfaceStyle
              .resolve(tokens, const [SurfacePadding.none])
              .copyWith(clipBehavior: Clip.antiAlias),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            scrollable: true,
            scrollController: scrollController,
            isFloatingAppBar: true,
            inheritMainBottomNavBarHeight: false,
            showViewPaddingBottom: false,
            padding: EdgeInsets.zero,
            appBar: appBar,
            toolBar: ToolBar.withActions(
              controller: toolBarController,
              useAttachments: true,
              onAttachmentPressed: addMarkdownAttachment,
            ),
            body: isEditing
                ? Form(
                    key: formKey,
                    child: _Body(controller: sheet, appBarHeight: appBarHeight),
                  )
                : _Body(controller: sheet, appBarHeight: appBarHeight),
          ),
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.controller, required this.appBarHeight});

  final ViewDeckListingSingleController controller;
  final double appBarHeight;

  @override
  Widget build(BuildContext context) {
    final deck = controller.deck;
    final helper = controller.helper;
    final tokens = context.themeTokens<AppTokens>();
    final headerHeight = 370.h;
    final tags = deck.tags.map((tag) => tag.name).toList(growable: false);
    final carouselImageUrls = helper.carouselImageUrls(deck);
    final isEditing = controller.state == DeckListingSheetState.editor;

    return Column(
      spacing: tokens.spaceLayoutGapXsm,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: headerHeight,
          child: Padding(
            padding: EdgeInsets.only(
              top: appBarHeight,
              left: tokens.spaceScaffoldPaddingXsm,
              right: tokens.spaceScaffoldPaddingXsm,
            ),
            child: Center(
              child: FormField<List<String>>(
                value: carouselImageUrls,
                listenable: controller,
                enabled: isEditing,
                valueReader: () {
                  return controller.helper.carouselImageUrls(controller.deck);
                },
                validator: DeckFormValidator.featuredImages,
                builder: (_, _) {
                  return AspectRatio(
                    aspectRatio: tokens.deckListingFeaturedImagesAspectRatio,
                    child: EditableCarousel(
                      imageSources: carouselImageUrls,
                      maxImageCount: 5,
                      isEditable: isEditing,
                      onImagePicked: controller.updateListingFeaturedImage,
                      shouldLoop: true,
                      autoScrollInterval: isEditing
                          ? null
                          : Duration(seconds: 3),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Surface(
          style: surfaceStyle.resolve(tokens, const [
            SurfaceShape.topRounded,
            SurfaceColor.muted,
            SurfaceBorder.top,
            SurfaceShadow.none,
            SurfacePadding.scaffoldButBottom,
          ]),
          child: Column(
            spacing: tokens.spaceLayoutGapMd,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                spacing: tokens.spaceLayoutGapSm,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DeckProfilesLabel(
                    profileName: deck.userProfile!.username,
                    profileAvatarUrl: deck.userProfile!.avatarUrl,
                    sourceProfileAvatarUrl:
                        ViewDeckSingleHelper.sourceProfileAvatarUrl(deck),
                    sourceProfileName: ViewDeckSingleHelper.sourceProfileName(
                      deck,
                    ),
                  ),
                  if (!isEditing)
                    Row(
                      spacing: tokens.spaceLayoutGapSm,
                      children: [
                        Button.icon(
                          icon: Icons.arrow_upward,
                          tokens: tokens,
                          onPressed: controller.isBusy
                              ? null
                              : controller.onUpvotePressed,
                        ),
                        Button.icon(
                          icon: Icons.arrow_downward,
                          tokens: tokens,
                          onPressed: controller.isBusy
                              ? null
                              : controller.onDownvotePressed,
                        ),
                        Button.icon(
                          icon: controller.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          tokens: tokens,
                          onPressed: controller.isBusy
                              ? null
                              : controller.onFavoritePressed,
                        ),
                      ],
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: tokens.spaceLayoutGapSm,
                children: [
                  MetaLabel(
                    label: NumberHelper.formatAbbreviatedCount(
                      helper.downloadsCount(deck),
                    ),
                    icon: Icons.download,
                  ),
                  MetaLabel(
                    label: NumberHelper.formatAbbreviatedCount(
                      controller.upvotesCount,
                    ),
                    icon: Icons.arrow_upward,
                  ),
                  MetaLabel(
                    label: NumberHelper.formatAbbreviatedCount(
                      controller.downvotesCount,
                    ),
                    icon: Icons.arrow_downward,
                  ),
                  MetaLabel(
                    label: NumberHelper.formatAbbreviatedCount(
                      controller.favoritesCount,
                    ),
                    icon: Icons.favorite,
                  ),
                ],
              ),
              SizedBox(
                height: 300.h,
                child: Center(
                  child: DeckTile(
                    deck: deck,
                    state: DeckTileState.spread,
                    width: 180.w,
                  ),
                ),
              ),
              DeckDetails(
                title: helper.title(deck),
                shortDescription: helper.shortDescription(deck),
                longDescription: helper.longDescription(deck),
                isEditable: isEditing,
                tags: tags,
                areTagsEditable: isEditing && deck.isEditable,
                tagsPlaceholder: deck.isEditable ? 'Add tags' : 'No tags yet',
                tagsTone: ChipTone.ghost,
                onTitleChanged: controller.updateTitle,
                onShortDescriptionChanged: controller.updateShortDescription,
                onLongDescriptionChanged: controller.updateLongDescription,
                onTagsChanged: controller.updateTags,
                metaLabels: Column(
                  spacing: tokens.spaceLayoutGapSm,
                  children: [
                    Row(
                      spacing: tokens.spaceLayoutGapSm,
                      children: [
                        MetaLabel(
                          icon: Icons.new_releases_outlined,
                          label: 'v${deck.version}+${deck.buildNumber}',
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
                        MetaLabel(
                          icon: Icons.update_outlined,
                          label: DateHelper.formatDateYyyyMmDd(deck.updatedAt),
                          tooltip:
                              'Published ${DateHelper.formatDateYyyyMmDd(deck.updatedAt)}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SectionEyebrow('Featured Cards'),
              if (isEditing)
                FormField<List<Map<String, dynamic>>>(
                  value: deck.listing?.featuredCards ?? const [],
                  listenable: controller,
                  valueReader: () {
                    return controller.deck.listing?.featuredCards ?? const [];
                  },
                  validator: DeckFormValidator.featuredCards,
                  builder: (_, _) => EditableFeaturedCardsColumn(
                    featuredCards: deck.listing?.featuredCards ?? const [],
                    isEditable: true,
                    onAddPressed: () => _addFeaturedCard(context),
                    maxCardCount: 3,
                  ),
                )
              else
                EditableFeaturedCardsColumn(
                  featuredCards: deck.listing?.featuredCards ?? const [],
                ),
              if (!isEditing) ...[DiscussionSection(sheet: controller)],
              ViewPaddingSizedBox(side: Side.bottom),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _addFeaturedCard(BuildContext context) async {
    final templates = controller.availableFeaturedCardTemplates();
    if (templates.isEmpty) {
      showSnackbar(
        context,
        message: 'You do not have any templates available for selection.',
      );
      return;
    }

    final selected = await showModal<CardTemplate>(
      context: context,
      title: 'Add featured card',
      child: SizedBox(
        height: 420,
        child: ListView.separated(
          itemCount: templates.length,
          separatorBuilder: (_, _) => SizedBox(
            height: context.themeTokens<AppTokens>().spaceLayoutGapMd,
          ),
          itemBuilder: (context, index) {
            final template = templates[index];

            return Center(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(template),
                child: ViewCardsTile.template(template: template),
              ),
            );
          },
        ),
      ),
    );
    if (selected == null) return;

    await controller.addListingFeaturedCard(selected);
  }
}
