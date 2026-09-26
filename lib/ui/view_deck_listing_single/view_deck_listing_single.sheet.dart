import 'package:boo_mondai/lib.barrel.dart'
    show
        AppBar,
        AppTokens,
        Button,
        ButtonColor,
        ChipTone,
        DateHelper,
        DeckDetails,
        DeckFormValidator,
        DeckTile,
        DeckTileState,
        ViewDiscussionSection,
        EditableCarousel,
        EditableCarouselController,
        EditableFeaturedCardsColumn,
        FormField,
        MetaLabel,
        NumberHelper,
        Scaffold,
        SectionEyebrow,
        Side,
        DecksDirectoryPaths,
        SurfaceBorder,
        SurfaceColor,
        SurfacePadding,
        SurfaceShadow,
        SurfaceShape,
        ToolBar,
        ViewCardsTile,
        ViewDeckListingSingleEditorController,
        ViewDeckListingSingleHelper,
        ViewDeckListingSinglePreviewController,
        ViewPaddingSizedBox,
        showBottomSheet,
        surfaceStyle,
        useToolBarController,
        DeckListingsService;
import 'package:boo_mondai/ui/view_deck_listing_single/view_deck_listing_single.barrel.dart';
import 'package:flutter/material.dart'
    hide FormField, Scaffold, AppBar, showBottomSheet;
import 'package:flutter_hooks/flutter_hooks.dart' show useEffect, useMemoized;

import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;
import 'package:signals_hooks/signals_hooks.dart';
import 'package:theme_variants/theme_variants.dart'
    show ThemeVariantsContext, Surface;

Future<void> showViewDeckListingSingleSheet<
  T extends ViewDeckListingSingleController
>({required BuildContext context, required T controller}) {
  return showBottomSheet(
    context: context,
    builder: (_) => ViewDeckListingSingleSheet(controller: controller),
  );
}

class ViewDeckListingSingleSheet<T extends ViewDeckListingSingleController>
    extends SignalHookWidget {
  const ViewDeckListingSingleSheet({super.key, required this.controller});

  final T controller;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();

    final helper = useMemoized(ViewDeckListingSingleHelper.new);

    final isEditing = controller is ViewDeckListingSingleEditorController;

    final toolBarController = useToolBarController();

    // ToDo: Eventually change this.
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(
            content: Text(
              controller.error.toString().replaceFirst('Exception: ', ''),
            ),
          ),
        );
      });
      return null;
    }, [controller.error]);

    List<Widget> getAppBarActions() {
      final children = <Widget>[];

      if (isEditing) {
        final editorController =
            controller as ViewDeckListingSingleEditorController;
        children.add(
          Button.icon(
            icon: editorController.getPublishedButtonIcon(),
            color: editorController.getPublishedButtonColor(),
            tokens: tokens,
            onPressed: () => editorController.togglePublished(context: context),
          ),
        );
        children.add(
          Button.icon(
            icon: Icons.delete_outline,
            color: ButtonColor.error,
            tokens: tokens,
            onPressed: editorController.deck.value.isEditable
                ? () => editorController.deleteListing(context: context)
                : null,
          ),
        );
      } else {
        final previewController =
            controller as ViewDeckListingSinglePreviewController;

        children.add(
          Button.icon(
            icon: previewController.isDownloading.value
                ? Icons.sync
                : Icons.cloud_download_outlined,
            color: ButtonColor.primary,
            tokens: tokens,
            onPressed: previewController.isDownloading.value
                ? null
                : previewController.onDownloadPressed,
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
              createAttachmentPath: (file) => DecksDirectoryPaths.attachment(
                deckTitle: controller.deck.value.title,
                fileNameWithoutExtension: file.name,
              ),
            ),
            body: isEditing
                ? Form(
                    key: (controller as ViewDeckListingSingleEditorController)
                        .formKey,
                    child: _Body(
                      helper: helper,
                      isEditing: isEditing,
                      controller: controller,
                      appBarHeight: appBarHeight,
                    ),
                  )
                : _Body(
                    helper: helper,
                    isEditing: isEditing,
                    controller: controller,
                    appBarHeight: appBarHeight,
                  ),
          ),
        );
      },
    );
  }
}

class _Body<T extends ViewDeckListingSingleController>
    extends SignalHookWidget {
  const _Body({
    required this.helper,
    required this.isEditing,
    required this.appBarHeight,
    required this.controller,
  });

  final ViewDeckListingSingleHelper helper;
  final bool isEditing;
  final T controller;
  final double appBarHeight;

  @override
  Widget build(BuildContext context) {
    final tokens = context.themeTokens<AppTokens>();
    final headerHeight = 370.h;

    final tags = controller.deck.value.tags
        .map((tag) => tag.name)
        .toList(growable: false);

    final featuredImages = DeckListingsService.getFeaturedImages(
      deck: controller.deck.value,
      listing: controller.listing.value,
    );
    final carouselController = useMemoized(
      () => EditableCarouselController(
        imageSources: featuredImages,
        isEditable: isEditing,
        maxImageCount: 5,
        autoScrollInterval: isEditing ? null : Duration(seconds: 3),
        shouldLoop: true,
      ),
      [isEditing, ...featuredImages],
    );

    useEffect(() {
      return carouselController.dispose;
    }, [carouselController]);

    final previewController =
        controller as ViewDeckListingSinglePreviewController;
    final editorController =
        controller as ViewDeckListingSingleEditorController;

    final deck = controller.deck.value;

    // ToDo: fix
    final templates = editorController.getFeaturedCardTemplates();

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
                value: featuredImages,
                enabled: isEditing,

                validator: DeckFormValidator.featuredImages,
                builder: (_, _) {
                  return AspectRatio(
                    aspectRatio: tokens.deckListingFeaturedImagesAspectRatio,
                    child: EditableCarousel(
                      controller: carouselController,
                      onImagePicked: editorController.upsertFeaturedImage,
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
                  // ToDo:
                  // DeckProfilesLabel(
                  //   profileName: controller.profile.value.username,
                  //   profileAvatar: controller.profile.value.avatarUrl,
                  //   sourceProfileAvatar:
                  //       ViewDeckSingleHelper.sourceProfileAvatarUrl(deck),
                  //   sourceProfileName: ViewDeckSingleHelper.sourceProfileName(
                  //     deck,
                  //   ),
                  // ),
                  if (!isEditing)
                    Row(
                      spacing: tokens.spaceLayoutGapSm,
                      children: [
                        Button.icon(
                          icon: Icons.arrow_upward,
                          tokens: tokens,
                          onPressed: previewController.isLoading.value
                              ? null
                              : previewController.onUpvotePressed,
                        ),
                        Button.icon(
                          icon: Icons.arrow_downward,
                          tokens: tokens,
                          onPressed: previewController.isLoading.value
                              ? null
                              : previewController.onDownvotePressed,
                        ),
                        Button.icon(
                          icon: previewController.isFavorite.value
                              ? Icons.favorite
                              : Icons.favorite_border,
                          tokens: tokens,
                          onPressed: previewController.isLoading.value
                              ? null
                              : previewController.onFavoritePressed,
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
                      helper.downloadsCount(controller.listing.value),
                    ),
                    icon: Icons.download,
                  ),
                  MetaLabel(
                    label: NumberHelper.formatAbbreviatedCount(
                      previewController.listing.value.upvotesCount,
                    ),
                    icon: Icons.arrow_upward,
                  ),
                  MetaLabel(
                    label: NumberHelper.formatAbbreviatedCount(
                      previewController.listing.value.downvotesCount,
                    ),
                    icon: Icons.arrow_downward,
                  ),
                  MetaLabel(
                    label: NumberHelper.formatAbbreviatedCount(
                      previewController.listing.value.favoritesCount,
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
                onTitleChanged: (value) => editorController.setTitle(value),
                onShortDescriptionChanged: editorController.setShortDescription,
                onLongDescriptionChanged: editorController.setLongDescription,
                onTagsChanged: editorController.setTags,
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
                          label: '${deck.cardTemplatesCount} cards',
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
                  value: controller.listing.value.featuredCards,

                  validator: DeckFormValidator.featuredCards,
                  builder: (_, _) => EditableFeaturedCardsColumn(
                    featuredCards: controller.listing.value.featuredCards,
                    isEditable: true,
                    onAddPressed: () => editorController.addFeaturedCard(
                      context: context,
                      modalChild: SizedBox(
                        height: 420,
                        child: ListView.separated(
                          itemCount: templates.length,
                          separatorBuilder: (_, _) => SizedBox(
                            height: context
                                .themeTokens<AppTokens>()
                                .spaceLayoutGapMd,
                          ),
                          itemBuilder: (context, index) {
                            final template = templates[index];

                            return Center(
                              child: GestureDetector(
                                onTap: () =>
                                    Navigator.of(context).pop(template),
                                child: ViewCardsTile.template(
                                  template: template,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    maxCardCount: 3,
                  ),
                )
              else
                EditableFeaturedCardsColumn(
                  featuredCards: controller.listing.value.featuredCards,
                ),
              if (!isEditing) ...[
                ViewDiscussionSection(rootContent: controller.content.value),
              ],
              ViewPaddingSizedBox(side: Side.bottom),
            ],
          ),
        ),
      ],
    );
  }
}
